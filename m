From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] - ignore bind mounts in fsck
Date: Thu, 20 Sep 2007 10:12:26 -0500
Message-ID: <46F28DDA.9050203@redhat.com>
References: <46F1847E.6080400@redhat.com> <20070919204249.GH25497@thunk.org> <46F2845C.2010000@redhat.com> <20070920144245.GD30221@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbXITPM3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 11:12:29 -0400
In-Reply-To: <20070920144245.GD30221@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Thu, Sep 20, 2007 at 09:31:56AM -0500, Eric Sandeen wrote:
>   
>> Agreed.  If you think fsck shouldn't silently cope with this mistake,
>> and instead punish the user for it (it is what they asked for, after
>> all), I'm ok with that too.  I'm willing to close my end as NOTABUG if
>> you don't want to take this patch.  :)
>>     
>
> I'm willing to take the patch, although I am thinking that it might be
> appropriate for fsck to print a warning message --- "Bind mount with
> non-zero fsck pass, skipping", or some such.
>
> What do you think?
>
> 							- Ted
>   
Yup, was  thinking the same.

----------------

An entry like this in /etc/fstab:

/foo	/bar	ext3	bind,defaults	1 3

will stop boot, as fsck.ext3 tries to check it and fails:

e2fsck 1.40.2 (12-Jul-2007)
fsck.ext3: Is a directory while trying to open /foo

The superblock could not be read or does not describe a correct ext2
filesystem. ...

Granted, asking for fsck of a bind mount in the fstab is a bit odd, 
but it doesn't seem like it should stop the boot process if you make
this mistake.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/misc/fsck.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/fsck.c
+++ e2fsprogs-1.40.2/misc/fsck.c
@@ -867,6 +867,16 @@ static int ignore(struct fs_info *fs)
 	if (fs->passno == 0)
 		return 1;
 
+	/*
+	 * If this is a bind mount, ignore it.
+	 */
+	if (opt_in_list("bind", fs->opts)) {
+		fprintf(stderr,
+			_("Skipping bind mount on %s with nonzero fsck pass\n"),
+			fs->mountpt);
+		return 1;
+	}
+
 	interpret_type(fs);
 
 	/*
