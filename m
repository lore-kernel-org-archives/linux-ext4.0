Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F98C4321A
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 354562084F
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556311553;
	bh=kxup9pbeMPrz441sCfHJyiiNF+VtDmn60MbeOTeDNvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FjoDolhZY+IoNsWrd6o8DQ42BYukfYmxYPuWFGO5iqcPp1yZUu13VzHOZzIxSOiSU
	 4Co0qiaAxSCr7MOYffIE2WsSdhkLvAWlIdwXN8jlQkEE6ZI08QLJSoZO+X8kTXforw
	 1u7EGeSfRAmUESzM6jzQjMnwUAh6tDimUFIPLiLE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfDZUpw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbfDZUpk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 Apr 2019 16:45:40 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0987B208CA;
        Fri, 26 Apr 2019 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556311540;
        bh=kxup9pbeMPrz441sCfHJyiiNF+VtDmn60MbeOTeDNvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqhrcanCfiXHpWEU8uEnozukmiq0BzwXNIaY3attDg6CJtO+rb6va9EiBle1sEFzM
         VV0QJ+wY/cZuTfuEE5Ie0JCCvG+wPjgx07Fxf2IYH/7QtpjGclkTBoMaDENG/m4ugc
         fUDWVKyJ597//Sha47nWTZZ2g8jg7S5cNN+AJSSg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [RFC PATCH 3/7] common/encrypt: support requiring other encryption settings
Date:   Fri, 26 Apr 2019 13:41:49 -0700
Message-Id: <20190426204153.101861-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
In-Reply-To: <20190426204153.101861-1-ebiggers@kernel.org>
References: <20190426204153.101861-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update _require_scratch_encryption() to support checking for kernel
support for contents and filenames encryption modes besides the default.
This will be used by some of the ciphertext verification tests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 54d873fa..37f16b94 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -4,6 +4,15 @@
 #
 # Functions for setting up and testing file encryption
 
+#
+# _require_scratch_encryption [-c CONTENTS_MODE] [-n FILENAMES_MODE]
+#
+# Require encryption support on the scratch device.
+#
+# This checks for support for the default type of encryption policy (AES-256-XTS
+# and AES-256-CTS).  Options can be specified to also require support for a
+# different type of encryption policy.
+#
 _require_scratch_encryption()
 {
 	_require_scratch
@@ -44,9 +53,58 @@ _require_scratch_encryption()
 		_notrun "kernel does not support $FSTYP encryption"
 	fi
 	rmdir $SCRATCH_MNT/tmpdir
+
+	# If required, check for support for the specific type of encryption
+	# policy required by the test.
+	if [ $# -ne 0 ]; then
+		_require_encryption_policy_support $SCRATCH_MNT "$@"
+	fi
+
 	_scratch_unmount
 }
 
+_require_encryption_policy_support()
+{
+	local mnt=$1
+	local dir=$mnt/tmpdir
+	local set_encpolicy_args=""
+	local c
+
+	OPTIND=2
+	while getopts "c:n:" c; do
+		case $c in
+		c|n)
+			set_encpolicy_args+=" -$c $OPTARG"
+			;;
+		*)
+			_fail "Unrecognized option '$c'"
+			;;
+		esac
+	done
+	set_encpolicy_args=${set_encpolicy_args# }
+
+	echo "Checking whether kernel supports encryption policy: $set_encpolicy_args" \
+		>> $seqres.full
+
+	mkdir $dir
+	_require_command "$KEYCTL_PROG" keyctl
+	_new_session_keyring
+	local keydesc=$(_generate_encryption_key)
+	if _set_encpolicy $dir $keydesc $set_encpolicy_args \
+		2>&1 >>$seqres.full | egrep -q 'Invalid argument'; then
+		_notrun "kernel does not support encryption policy: '$set_encpolicy_args'"
+	fi
+	# fscrypt allows setting policies with modes it knows about, even
+	# without kernel crypto API support.  E.g. a policy using Adiantum
+	# encryption can be set on a kernel without CONFIG_CRYPTO_ADIANTUM.
+	# But actually trying to use such an encrypted directory will fail.
+	if ! touch $dir/file; then
+		_notrun "encryption policy '$set_encpolicy_args' is unusable; probably missing kernel crypto API support"
+	fi
+	$KEYCTL_PROG clear @s
+	rm -r $dir
+}
+
 _scratch_mkfs_encrypted()
 {
 	case $FSTYP in
-- 
2.21.0.593.g511ec345e18-goog

