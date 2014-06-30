From: "Burton, Ross" <ross.burton@intel.com>
Subject: Re: [PATCH] misc: copy extended attributes in populate_fs
Date: Mon, 30 Jun 2014 19:59:03 +0100
Message-ID: <CAJTo0LZL4JMsza7XWkTjT0rPXvbhiYwbgXXJj9AWdohP6TiK7w@mail.gmail.com>
References: <1403902937-2781-1-git-send-email-ross.burton@intel.com>
 <1403902937-2781-2-git-send-email-ross.burton@intel.com> <20140630184346.GF9743@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
	tytso <tytso@mit.edu>, Robert Yang <liezhi.yang@windriver.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:40811 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaF3S7Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2014 14:59:24 -0400
Received: by mail-qg0-f49.google.com with SMTP id f51so2340817qge.22
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2014 11:59:23 -0700 (PDT)
In-Reply-To: <20140630184346.GF9743@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 30 June 2014 19:43, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> +     retval = ext2fs_xattrs_open(fs, ino, &handle);
>
> If the FS does not have at least one of the inline_data or ext_attr features
> turned on, the ext2fs_xattrs_open call returns EXT2_ET_MISSING_EA_FEATURE,
> which aborts the whole operation.  Is that ok?

Good point.

I'm currently dithering over whether this should silently do nothing,
or warn per file, or have an already-warned boolean to avoid spamming
the user.

>> +     if (retval) {
>> +             com_err(__func__, errno, "while opening inode %u", ino);
>
> retval, not errno.

Literally just squashing some commits for these error paths which went wrong.

>> +             return errno;
>> +     }
>> +
>> +     list = malloc(size);
>
> What happens if malloc fails?

You're doomed?

What's e2fsprog's policy on OOM - I see some instances of checked
malloc() that exit() promptly, others that simply return 0 and hope
for the best, and some that use fputs() and gettext() - but if we're
OOM then that's even more likely to fail.

I'll follow the official line, but what that line is isn't clear from
a sample of malloc() calls in the source.

>> +     size = llistxattr(filename, list, size);
>
> What if this second call should fail for some reason?  Shouldn't we stop?

Yes, also fixed locally.

>> +
>> +     for (i = 0; i < size; i += strlen(&list[i]) + 1) {
>> +             const char *name = &list[i];
>> +             char *value;
>> +
>> +             value_size = getxattr(filename, name, NULL, 0);
>
> What if getxattr returns -1?

Should bail, will fix.

>> +             value = malloc(value_size);
>> +             value_size = getxattr(filename, name, value, value_size);
>
> Same complaints about not checking malloc/getxattr return values.

Agreed.

>> +     retval = ext2fs_xattrs_close(&handle);
>> +     if (retval)
>> +             com_err(__func__, errno, "while closing inode %u", ino);
>
> retval, not errno.

[sags head in shame]

Next time I'm patching at 10pm I'll remember to review the patch the
next morning before sending...

Ross
