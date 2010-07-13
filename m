From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Re: [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes to mount
Date: Mon, 12 Jul 2010 18:08:51 -0700
Message-ID: <AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
References: <871vbax86w.fsf@patl.com>
	<87zkxyvtjt.fsf@patl.com>
	<3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58443 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0GMBIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jul 2010 21:08:52 -0400
In-Reply-To: <3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 12, 2010 at 5:21 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2010-07-11, at 11:04, Patrick J. LoPresti wrote:
> >
>> + =A0 =A0 /* Absolute addressability check (borrowed from ext4/super=
=2Ec) */
>> + =A0 =A0 if ((max_block >
>> + =A0 =A0 =A0 =A0 =A0(sector_t)(~0LL) >> (osb->sb->s_blocksize_bits =
- 9)) ||
>> + =A0 =A0 =A0 =A0 (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT =
