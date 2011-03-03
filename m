From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks to Uninit Exts
Date: Wed, 2 Mar 2011 17:56:52 -0700
Message-ID: <4CB90DB0-DA5C-4A64-9DC0-53F46BE40915@dilger.ca>
References: <4D6C6318.2010105@linux.vnet.ibm.com> <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca> <20110302202313.GA15097@dastard>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:35242 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1CCA45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Mar 2011 19:56:57 -0500
In-Reply-To: <20110302202313.GA15097@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-02, at 13:23, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Feb 28, 2011 at 11:42:48PM -0700, Andreas Dilger wrote:
>> On 2011-02-28, at 8:08 PM, Allison Henderson wrote:
>>> This first patch adds a function to convert a range of blocks
>>> to an uninitialized extent.  This function will
>>> be used to first convert the blocks to extents before
>>> punching them out.
>> 
>> This was proposed as a separate function for FALLOCATE by Dave
>> Chinner (based on XFS_IOC_ZERO_RANGE), so this is useful as a
>> standalone function.
> 
> XFS_IOC_ZERO_RANGE converts a range to unwritten extents, not
> uninitialised extents. An uninitialised extent is one that is
> allocated but had not data written to it (i.e. contains stale data),
> while an unwritten/preallocated extent is guaranteed to contain
> zeros.

For ext4 at least there is no distinction at least. Still, it is good to use the right terms so that we are all on the same page. 

>  This may be just a terminology issue, but we should try to
> use the same jargon across all filesystems...

Cheers, Andreas