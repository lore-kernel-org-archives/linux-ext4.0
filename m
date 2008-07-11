From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: [PATCH] e2fsprogs : Fix memory leak in ext2fs_initialize.
Date: Sat, 12 Jul 2008 00:23:43 +0530
Message-ID: <ea11fea30807111153s38fc01e2w291e120da947a873@mail.gmail.com>
References: <ea11fea30807110332n459593eay3ce43cca67d5c676@mail.gmail.com>
	 <20080711184149.GB26656@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:48345 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbYGKSxs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 14:53:48 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1848444tic.23
        for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 11:53:43 -0700 (PDT)
In-Reply-To: <20080711184149.GB26656@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 12, 2008 at 12:11 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Jul 11, 2008 at 04:02:06PM +0530, Manish Katiyar wrote:
>> +     if (buf) {
>> +      ext2fs_free_mem(&buf);
>> +     }
>
> I'll fix this up and apply, but in the future, please respect the
> surrounding whitespace rules of the source code.  For e2fsprogs that
> means (among other things) each level is indented 8 spaces, no curly
> braces are needed for single statements, and no white space at the end
> of lines.

Thanks a lot Ted,
 I will keep that in mind in future. I am not sure from where did
those white spaces came, I don't have them in my git log.....and curly
braces for single statements were because I copied the style from
below line in ext2fs_free() .... perhaps a bad example which I chose
to follow :-(

	if (fs->io) {
		io_channel_close(fs->io);
	}

Thanks -


>
> Thanks,
>
>                                                        - Ted
>



-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
