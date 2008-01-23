From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Tue, 22 Jan 2008 21:55:37 -0600
Message-ID: <4796BAB9.7000502@redhat.com>
References: <20080122231707.GA21968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYAWD4A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 22:56:00 -0500
In-Reply-To: <20080122231707.GA21968@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> As discussed on RFC, this flag is simply a generic "this is a
> crash/burn test filesystem" marker.  If it is set, then filesystem
> code which is "in development" will be allowed to mount the
> filesystem.  Filesystem code which is not considered ready for
> prime-time will check for this flag, and if it is not set, it will
> refuse to touch the filesystem.
> 
> As we start rolling ext4 out to distro's like Fedora, et. al, this
> makes it less likely that a user might accidentally start using ext4
> on a production filesystem; a bad thing, since that will essentially
> make it be unfsckable until e2fsprogs catches up.
> 
> 						- Ted
> 

Overall, seems ok.  One other question though, when ext4 is a
fully-fledged production filesystem, and the flag requirement is gone,
what stops ext3 filesystems from being silently mounted as ext4, just as
happened with ext4dev today?  Will users need to be sure everything
explicitly mounts -t ext3 to avoid this?


+static void parse_extended_opts(ext2_filsys fs, const char *opts)

...

+		if (!strcmp(token, "test_fs")) {
+			fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
+			printf("Setting test filesystem flag\n");
+			ext2fs_mark_super_dirty(fs);
+		} else if (!strcmp(token, "production_fs")) {
+			fs->super->s_flags &= ~EXT2_FLAGS_TEST_FILESYS;
+			printf("Clearing test filesystem flag\n");
+			ext2fs_mark_super_dirty(fs);
+		} else
+			r_usage++;
+	}
+	if (r_usage) {
+		fprintf(stderr, _("\nBad options specified.\n\n"
+			"Extended options are separated by commas, "
+			"and may take an argument which\n"
+			"\tis set off by an equals ('=') sign.\n\n"
+			"Valid extended options are:\n"
+			"\ttestfs\n"));

help text doesn't match reality here, missing a "_"

-Eric
