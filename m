From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: ext2_block_alloc_info
Date: Wed, 24 Dec 2008 12:15:59 +0530
Message-ID: <37d33d830812232245r2a33bc73vf62be3ac655c6e32@mail.gmail.com>
References: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>
	 <804dabb00812201725r304bed36ufc56ebc2393e2299@mail.gmail.com>
	 <170fa0d20812221856j4c660384nc2ac693ca8fd0ba4@mail.gmail.com>
	 <804dabb00812222029x76d34c24o798ade5dd0e31351@mail.gmail.com>
	 <37d33d830812222037s362060c3i8278a8a39083c50f@mail.gmail.com>
	 <20081223080545.GI5000@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Peter Teoh" <htmldeveloper@gmail.com>,
	"Mike Snitzer" <snitzer@gmail.com>,
	"Rohit Sharma" <imreckless@gmail.com>,
	Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	"Chetan Risbud" <chetan.risbud@gmail.com>,
	"Bharti Alatgi" <bharati.alatgi@gmail.com>
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:10453 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYLXGqA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Dec 2008 01:46:00 -0500
Received: by wa-out-1112.google.com with SMTP id n7so1468496wag.13
        for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 22:45:59 -0800 (PST)
In-Reply-To: <20081223080545.GI5000@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks a lot Peter and Andreas for taking out time and going through fscops.
We welcome all your suggestion.

We will soon be uploading all the docs/sources on to the web.
Stay tuned !!!

Thanks,
Again

On Tue, Dec 23, 2008 at 1:35 PM, Andreas Dilger <adilger@sun.com> wrote:
> On Dec 23, 2008  10:07 +0530, Sandeep K Sinha wrote:
>> I have a tool ready with unfolds a file system completely thrugh
>> ioctl. You will just have to patch the kernel.
>> And that also, its for ext2.
>
> It would be much more generic to use the FIEMAP ioctl, which has made
> it into the 2.6.28 kernel.  It will currently only dump the file data
> and xattr blocks, but it is designed to be extensible to allow dumping
> other kinds of inode metadata (e.g. indirect/index blocks, etc).
>
>> But its really verbose.
>
> There are patches to e2fsprogs to allow filefrag to call FIEMAP to dump
> the file layout.  They were posted to this list a few months ago, and
> are scheduled for upstream inclusion.  While they will be part of e2fsprogs,
> the FIEMAP ioctl is a generic mechanism that is supported by ext2/3/4,
> OCFS, and XFS, and hopefully more now that it is in the kernel.
>
>> You can have a look for the sources @ http://code.google.com/p/fscops/
>> We will be uploading the tool there soon.
>
> While the description of "What OHSM offer" sounds really good, I couldn't
> find any code or description of what is actually implemented.  Is this
> a system that actually works, or is it only describing what you would like
> OHSM to do?
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>



-- 
Regards,
Sandeep.





 	
"To learn is to change. Education is a process that changes the learner."
