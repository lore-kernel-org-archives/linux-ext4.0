From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: File limit inside a single directory
Date: Fri, 13 Feb 2015 13:52:53 -0500
Message-ID: <20150213185253.GB26115@thunk.org>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55>
 <54DD0091.1050104@redhat.com>
 <B52A17D2-8AD8-4427-B1D3-2FE6DE21585B@dilger.ca>
 <trinity-232bc979-0b76-4776-a65c-b6697428d0a4-1423846162245@3capp-webde-bs16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: suntrop@web.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45959 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbbBMSw4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2015 13:52:56 -0500
Content-Disposition: inline
In-Reply-To: <trinity-232bc979-0b76-4776-a65c-b6697428d0a4-1423846162245@3capp-webde-bs16>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 13, 2015 at 05:49:22PM +0100, suntrop@web.de wrote:
> Thanks guys. I was afraid of having a couple 100K (at most). The
> server support team told me not to have more than 10 to 20K. There
> seems to be a misconception (for me and people from the CMS) about
> the 32K subdirectory limit, but this ins't for files/folders within
> a single directory but rather nested directories like
> /1/2/3.../32000

In general the limitation you will hit first is one of performance,
rather than a hard limit.  Using nested directories, i.e.,
/home/t/y/t/tytso will generally be a performance win if you can do
it.

Cheers,

					- Ted
