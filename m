From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: Ext4:can not rm directories on 2.6.3x
Date: Fri, 15 Mar 2013 11:12:02 -0400
Message-ID: <51433A42.2090400@windriver.com>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com> <513EDC2B.9020604@gmail.xom> <20130312134229.GJ18595@thunk.org> <513FF163.7080606@gmail.xom> <5142CAE4.3070400@gmail.xom> <20130315145314.GB7403@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: zhuyj <zyjzyj2000@gmail.com>, <linux-ext4@vger.kernel.org>,
	<stable@kernel.org>, Willy Tarreau <w@1wt.eu>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:60390 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3COPNF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2013 11:13:05 -0400
In-Reply-To: <20130315145314.GB7403@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13-03-15 10:53 AM, Theodore Ts'o wrote:
> On Fri, Mar 15, 2013 at 03:16:52PM +0800, zhuyj wrote:
>> Hi, all
>>
>> The two patches can fix this problem.
>> ext4: Fix fs corruption when make_indexed_dir() fails
>> ext4: don't dereference null pointer when make_indexed_dir() fails
> 
> Thanks, Zhujh for figuring this out.  Those two patches weren't
> taggled with cc: stable@vger.kernel.org, but they probably should have
> been.  Since they first appeared in v3.0, the two long-term stable
> kernels that would benefit with these patches are v3.0.x and v3.2.x.
> 
> Willy, Paul, would you consider cherry-picking the following commits
> for your respective stable kernels?

Both queued for 2.6.34.15

Thanks,
Paul.
--

> 
> git cherry-pick 7ad8e4e6ae2a7c95445ee1715b1714106fb95037
> git cherry-pick 6976a6f2acde2b0443cd64f1d08af90630e4ce81
> 
> Thanks!!
> 
> 				- Ted
> 
