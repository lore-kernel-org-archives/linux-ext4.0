From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/4] tune2fs: Add support for orphan_file feature
Date: Mon, 25 May 2015 10:16:27 -0600
Message-ID: <00D427E7-DF68-4934-87E2-10D34032883E@dilger.ca>
References: <1432294137-26078-1-git-send-email-jack@suse.cz> <1432294137-26078-5-git-send-email-jack@suse.cz> <20150522171842.GA830@birch.djwong.org> <20150525073831.GB2387@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35875 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbbEYQQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 May 2015 12:16:31 -0400
Received: by pdfh10 with SMTP id h10so72161893pdf.3
        for <linux-ext4@vger.kernel.org>; Mon, 25 May 2015 09:16:30 -0700 (PDT)
In-Reply-To: <20150525073831.GB2387@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On May 25, 2015, at 1:38 AM, Jan Kara <jack@suse.cz> wrote:
> 
> On Fri 22-05-15 10:18:42, Darrick J. Wong wrote:
>> On Fri, May 22, 2015 at 01:28:57PM +0200, Jan Kara wrote:
>>> @@ -1970,6 +2011,31 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
>>> 				continue;
>>> 			}
>>> 			ext_mount_opts = strdup(arg);
>>> +		} else if (!strcmp(token, "orphan_file_size")) {
>>> +			__u64 size;
>>> +
>>> +			if (!arg) {
>>> +				r_usage++;
>>> +				continue;
>>> +			}
>>> +			size = strtoul(arg, &p, 0);
>> 
>> Would be nice if I could supply units, e.g. orphan_file_size = 128K here.
> 
> I don't mind doing this but do we have precedens in any option? Because
> e.g. journal size is just a number (in megabytes), stripe options are in fs
> blocks. For orphan file megabytes are too coarse. I can make the unit
> fs-blocks, or kbytes, or leave it at bytes, or allow specifying units but
> some consistency would be good. Any opinion?

Use "parse_num_blocks2()" for this.  This is used to parse the filesystem size in mke2fs,
blocksize, bigalloc cluster size, resize, etc.  You are right that the journal_size is
NOT using this helper, but it probably should.

Cheers, Andreas


>>> +			if (*p) {
>>> +				fprintf(stderr,
>>> +					_("Invalid size of orphan file %s\n"),
>>> +					arg);
>>> +				r_usage++;
>>> +				continue;
>>> +			}
>>> +			if (size < EXT4_MIN_ORPHAN_FILE_SIZE) {
>>> +				fprintf(stderr,
>>> +					_("Orphan file is too small. Minimum "
>>> +					  "size is %u\n"),
>>> +					EXT4_MIN_ORPHAN_FILE_SIZE);
>>> +				r_usage++;
>>> +				continue;
>>> +			}
>>> +			orphan_file_blocks = (size + fs->blocksize - 1) /
>>> +						fs->blocksize;
>>> 		} else
>>> 			r_usage++;
>>> 	}
>>> @@ -2921,6 +2987,17 @@ retry_open:
>>> 		if (rc)
>>> 			goto closefs;
>>> 	}
>>> +	if (orphan_file_blocks) {
>> 
>> If someone specifies -E orphan_file_size=NNN -O ^orphan_file, does this have
>> the effect of erasing and recreating the orphan file?
> 
> Yes, although that's a side-effect of the option parsing :) Intended use
> is that you first disable the orphan_file feature and then enable it again
> with new size.
> 
> 									Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





