From: Andrew Lutomirski <andy@luto.us>
Subject: Re: How do I clear the append-only flag on symlinks?
Date: Sat, 22 Oct 2011 01:57:45 -0700
Message-ID: <CAObL_7F+Dhv8hFBkVN6q2oP_CBKnN2EbqmzfmqVh-KjOsyMkTw@mail.gmail.com>
References: <CAObL_7FLTio3+X3iQ3sdHw156OvmjT92_AD0vKTSagNTkaF9fQ@mail.gmail.com>
 <20111022051644.GD4196@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1JVI6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Oct 2011 04:58:06 -0400
Received: by iaek3 with SMTP id k3so5689295iae.19
        for <linux-ext4@vger.kernel.org>; Sat, 22 Oct 2011 01:58:05 -0700 (PDT)
In-Reply-To: <20111022051644.GD4196@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 10:16 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Oct 21, 2011 at 11:07:51AM -0700, Andrew Lutomirski wrote:
>> By means that are best not admitted to, I managed to mark a large
>> chunk of my filesystem append-only, including symlinks. =A0I cleared=
 the
>> flag from all the normal files and directories, but chattr and lsatt=
r
>> don't want to operate on symlinks.
>
> Yes. =A0So how did you set a whole chunk of your file system
> append-only?

I want to be able to write to shared, locked, writable mappings
without sleeping.  Updating file timestamps and stable pages get in
the way.  I was trying out an approach to fixing the file_update_call
in do_wp_page using a new inode flag.  Sadly, I figured out the hard
way that 8196 is not actually a power of two.  (My patch is also
garbage for other reasons, but I'll email out a different approach as
an RFC sometime soon.)

If you have any ideas for how to handle stable pages other than
carrying a patch to disable them, I'd love to hear it.  The obvious
approach of making a new writable copy of the page will involve
pagecache internals that I'm not at all familiar with.

>
>> Any ideas on how to clear the append-only flags? =A0debug2fs is a li=
ttle
>> scary, and hacking e2fsprogs to allow operation on symlinks seems to
>> affect symlink targets and not the symlinks themselves.
>
> I'd probably hack it into e2fsck, and let it offer to clear the
> append-only flag on things that aren't regular files, on the theory
> that they should have never been allowed to be set to begin with.
>

I'll take a look on Monday.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
