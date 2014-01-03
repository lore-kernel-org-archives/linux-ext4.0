From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 2/2] populate-extfs.sh: espace the space in the filename
Date: Fri, 3 Jan 2014 04:15:41 -0500
Message-ID: <1388740541-28123-3-git-send-email-liezhi.yang@windriver.com>
References: <1388740541-28123-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <sgh@sgh.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:55016 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaACJP5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jan 2014 04:15:57 -0500
In-Reply-To: <1388740541-28123-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46rom: S=C3=B8ren Holm <sgh@sgh.dk>

The filename which contains space would not get into the final
ext2/3/4 filsystem without this patch

Signed-off-by: S=C3=B8ren Holm <sgh@sgh.dk>
Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 contrib/populate-extfs.sh |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)
 mode change 100755 =3D> 100644 contrib/populate-extfs.sh

diff --git a/contrib/populate-extfs.sh b/contrib/populate-extfs.sh
old mode 100755
new mode 100644
index b1d3d1f..a84ec74
--- a/contrib/populate-extfs.sh
+++ b/contrib/populate-extfs.sh
@@ -44,7 +44,7 @@ fi
 		fi
=20
 		# Only stat once since stat is a time consuming command
-		STAT=3D$(stat -c "TYPE=3D\"%F\";DEVNO=3D\"0x%t 0x%T\";MODE=3D\"%f\";=
U=3D\"%u\";G=3D\"%g\"" $FILE)
+		STAT=3D$(stat -c "TYPE=3D\"%F\";DEVNO=3D\"0x%t 0x%T\";MODE=3D\"%f\";=
U=3D\"%u\";G=3D\"%g\"" "$FILE")
 		eval $STAT
=20
 		case $TYPE in
@@ -52,20 +52,20 @@ fi
 			echo "mkdir $TGT"
 			;;
 		"regular file" | "regular empty file")
-			echo "write $FILE $TGT"
+			echo "write \"$FILE\" \"$TGT\""
 			;;
 		"symbolic link")
-			LINK_TGT=3D$(readlink $FILE)
-			echo "symlink $TGT $LINK_TGT"
+			LINK_TGT=3D$(readlink "$FILE")
+			echo "symlink \"$TGT\" \"$LINK_TGT\""
 			;;
 		"block special file")
-			echo "mknod $TGT b $DEVNO"
+			echo "mknod \"$TGT\" b $DEVNO"
 			;;
 		"character special file")
-			echo "mknod $TGT c $DEVNO"
+			echo "mknod \"$TGT\" c $DEVNO"
 			;;
 		"fifo")
-			echo "mknod $TGT p"
+			echo "mknod \"$TGT\" p"
 			;;
 		*)
 			echo "Unknown/unhandled file type '$TYPE' file: $FILE" 1>&2
@@ -73,11 +73,11 @@ fi
 		esac
=20
 		# Set the file mode
-		echo "sif $TGT mode 0x$MODE"
+		echo "sif \"$TGT\" mode 0x$MODE"
=20
 		# Set uid and gid
-		echo "sif $TGT uid $U"
-		echo "sif $TGT gid $G"
+		echo "sif \"$TGT\" uid $U"
+		echo "sif \"$TGT\" gid $G"
 	done
=20
 	# Handle the hard links.
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
