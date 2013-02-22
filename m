From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Fri, 22 Feb 2013 13:03:25 -0500
Message-ID: <20130222180325.GB21264@thunk.org>
References: <87obfcs1x6.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49471 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758860Ab3BVSD3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2013 13:03:29 -0500
Content-Disposition: inline
In-Reply-To: <87obfcs1x6.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2013 at 09:17:57PM +0400, Dmitry Monakhov wrote:
> 
> 301'th xfstests are failed due to :
> commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
> Author: Zheng Liu <wenqing.lz@taobao.com>
> Date:   Mon Feb 18 00:29:59 2013 -0500
> 
>     ext4: lookup block mapping in extent status tree
> 
> TESTCASE: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0

Thanks for the heads up.  I haven't updatied the xfstests I've been
using yet, since I want to make sure I'm comparing apples and oranges
during the merge window when I'm checking for regressions; I'll update
my xfstests in a week or two after the merge window settles down, and
then I'll rerun my baseline tests using the updated xfstests against
3.8.0 and 3.9-rc2 or 3.9-rc3.

(And furthermore, these new xfstests aren't yet in xfstests upstream
yet, right?  Any comments from the xfstests maintainer about whether
they are going to be willing to take your proposed new test cases?)

So when you say this is a regression, I take it that this test #301
doesn't fail on commit d100eef2440f^, but it does fail on d100eef2440f,
correct?

						- Ted
