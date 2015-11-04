From: Jan Kara <jack@suse.com>
Subject: [PATCH 3/4] common: Add function for selecting from different output files
Date: Wed,  4 Nov 2015 17:31:37 +0100
Message-ID: <1446654698-23577-4-git-send-email-jack@suse.com>
References: <1446654698-23577-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965622AbbKDQbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2015 11:31:51 -0500
In-Reply-To: <1446654698-23577-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add function for selection of different output files. The idea is that
in config file ($seq.cfg) there are several lines like:

feat1,feat2: suffix

The function is passed a feature string (or uses MOUNT_OPTIONS if no
argument is passed) and selects output file with a suffix for which all
features are present in the feature string. If there is no matching
line, output with 'default' suffix is selected.

Signed-off-by: Jan Kara <jack@suse.com>
---
 common/rc | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/common/rc b/common/rc
index adf1edf64d8d..543780c92c59 100644
--- a/common/rc
+++ b/common/rc
@@ -3142,6 +3142,47 @@ get_block_size()
 	echo `stat -f -c %S $1`
 }
 
+_select_output()
+{
+	if [ $# -eq 0 ]; then
+		FEATURES=${MOUNT_OPTIONS##"-o "}
+	else
+		FEATURES=$1
+	fi
+
+	export FEATURES
+	seqfull=$SRC_DIR/$seqnum
+	perl -e '
+		my %feathash;
+		my $feature, $result, $suffix, $opts;
+
+		foreach $feature (split(/,/, $ENV{"FEATURES"})) {
+			$feathash{$feature} = 1;
+		}
+		$result = "default";
+		while (<>) {
+			my $found = 1;
+
+			chomp;
+			($opts, $suffix) = split(/ *: */);
+			foreach my $opt (split(/,/, $opts)) {
+				if (!exists($feathash{$opt})) {
+					$found = 0;
+					last;
+				}
+			}
+			if ($found == 1) {
+				$result = $suffix;
+				last;
+			}
+		}
+		print $result
+		' <$seqfull.cfg | {
+			read SUFFIX
+			ln -fs $seq.out.$SUFFIX $seqfull.out
+		}
+}
+
 init_rc
 
 ################################################################################
-- 
2.1.4

