#!/usr/local/bin/ksh93 -p
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
. $STF_SUITE/include/libtest.kshlib

################################################################################
#
# __stc_assertion_start
#
# ID: zpool_export_003_neg
#
# DESCRIPTION: 
#       'zpool export' should return an error with badly formed parameters,
#
# STRATEGY:
#	1. Create an array of parameters
#	2. For each parameter in the array, execute 'zpool export'
#	3. Verify an error is returned.
#
# TESTABILITY: explicit
#
# TEST_AUTOMATION_LEVEL: automated
#
# CODING_STATUS: COMPLETED (2005-07-04)
#
# __stc_assertion_end
#
###############################################################################

verify_runnable "global"

function cleanup
{
	typeset dir=$(get_device_dir $DISKS)
	datasetexists "$TESTPOOL/$TESTFS" || \
		log_must $ZPOOL import -d $dir $TESTPOOL

	ismounted "$TESTPOOL/$TESTFS"
	(( $? != 0 )) && \
	    log_must $ZFS mount $TESTPOOL/$TESTFS
}

log_onexit cleanup

set -A args "" "-f" "-? $TESTPOOL" "-QWERTYUIO $TESTPOOL"

log_assert "'zpool export' should return an error with badly-formed parameters."

typeset -i i=0
while (( $i < ${#args[*]} )); do
	log_mustnot $ZPOOL export ${args[i]}
	((i = i + 1))
done

log_pass "'zpool export' badly formed parameters fail as expected."
