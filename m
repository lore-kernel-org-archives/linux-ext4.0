From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
Date: Thu, 11 Apr 2013 10:56:20 -0400
Message-ID: <20130411145620.GC8609@thunk.org>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com>
 <20130411035826.GA18878@thunk.org>
 <alpine.LFD.2.00.1304111013191.10609@dhcp-1-230.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33551 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab3DKO4Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 10:56:24 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1304111013191.10609@dhcp-1-230.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 11, 2013 at 10:18:16AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Thanks, but Dmitry is right, the check should be before the
> journal_start() call.

Whoops!  I'm not sure how I screwed that up.  Thanks for catching
that, Dmitry!

> I am not sure how much work will it be for you, but would it be
> possible to resend patch to the list when you change it ? Just to
> make sure we do not get unnecessary problems.

Yes, I'll try to do that in the future.  Here's the revised patch....

     	      	    	    	- Ted

commit 3b296c66fe6f9a6ed44b0b83f4f2ae87d8874af6
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Apr 11 10:54:46 2013 -0400

    ext4: do not convert to indirect with bigalloc enabled
   =20
    With bigalloc feature enabled we do not support indirect addressing=
 at all
    so we have to prevent extent addressing to indirect addressing
    conversion in this case. The problem has been introduced with the c=
ommit
    "ext4: support simple conversion of extent-mapped inodes to use i_b=
locks"
   =20
    Signed-off-by: Lukas Czerner <lczerner@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index d129a4d..49e8bdf 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -625,6 +625,10 @@ int ext4_ind_migrate(struct inode *inode)
 	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EINVAL;
=20
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+		return -EOPNOTSUPP;
+
 	handle =3D ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
