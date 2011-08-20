From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Sat, 20 Aug 2011 09:58:38 -0600
Message-ID: <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
References: <1313780769-21713-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "adilger@dilger.ca" <adilger@dilger.ca>,
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Aditya Kali <adityakali@google.com>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:4908 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1HTP6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Aug 2011 11:58:03 -0400
In-Reply-To: <1313780769-21713-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-19, at 1:06 PM, Aditya Kali <adityakali@google.com> wrote:

> This patch is an attempt towards supporting quotas as first class
> feature in ext4. It is based on the proposal at:
> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4
> This patch introduces a new feature - EXT4_FEATURE_RO_COMPAT_QUOTA which, when
> turned on, enables quota accounting at mount time iteself. 

> 6) With the QUOTA feature set, since the quota inodes are hidden, some of the
>   utilities from quota-tools will no longer work correctly. Instead, e2fsprogs
>   will include support for fixing the quota files.

It would be preferable from a usability point of view to have the existing quota tools to work with the new quota files instead of having to introduce new quota utilities. 

There are a number of ways that this could be facilitated:
- make the quota files visible to userspace, but immutable
- add the needed calls to the existing quota tools and use them when manipulating quotas on ext4 filesystems with this feature
- add library interfaces for doing the quota changes to libext2fs (or a new very simple library) and have the quota tools link to that instead of interfacing to the kernel directly 

Cheers, Andreas