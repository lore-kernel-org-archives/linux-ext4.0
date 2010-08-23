From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Updated test case
Date: Mon, 23 Aug 2010 12:05:17 -0600
Message-ID: <54539A08-DC60-4A0C-A00A-2CC2EC4472D1@dilger.ca>
References: <E1OlvNi-00063m-09@tytso-glaptop> <20100821201146.GF10450@thunk.org> <4C7071EA.3040503@redhat.com> <20100822114228.GB6329@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63062 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HWSFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Aug 2010 14:05:18 -0400
In-Reply-To: <20100822114228.GB6329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-22, at 05:42, Ted Ts'o wrote:
> On Sat, Aug 21, 2010 at 07:40:10PM -0500, Eric Sandeen wrote:
>> I'll send an xfstest but it'd be really great if could could work
>> inside the xfstests framework when devising testcases...
> 
> If you could put together an xfstests, that would be great.  I hadn't
> because Mike's been trying to remind me that I really need to delegate
> to others :-), and we do have someone at Google who can put the
> xfstest script together.  You can probably do it faster than he can,
> though.

That reminds me that I have a 90% completed version of fsx that has fallocate() calls with both KEEP_SIZE and without.  I was just lacking a suitable place to do testing for it and fix any remaining issues...  If there was someone around who could test this it would be great.

Cheers, Andreas





