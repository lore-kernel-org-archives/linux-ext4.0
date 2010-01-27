From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: Re: journal forget may introduce buffer aliasing problem?
Date: Wed, 27 Jan 2010 13:58:54 +0800
Message-ID: <7bb361261001262158q37fe060br93c751c1152c5738@mail.gmail.com>
References: <7bb361261001261944v7b5d698bn9da51d1f418c1594@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f186.google.com ([209.85.223.186]:42823 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0A0F6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 00:58:55 -0500
Received: by iwn16 with SMTP id 16so806883iwn.5
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 21:58:54 -0800 (PST)
In-Reply-To: <7bb361261001261944v7b5d698bn9da51d1f418c1594@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, I haven't seen unmap_underlying_metadata code in __block_prepare_=
write
so just forget this mail, sorry.

2010/1/27 =B6=A1=B6=A8=BB=AA <dingdinghua85@gmail.com>:
> Hi all:
>       The following is my analysis(if wrong, please point it out),
> may be I can send a patch out if it's a bug.
>       If buffer_head belongs to comitting transaction,
> jbd2_journal_forget do nothing except discard it from running
> transaction. So this buffer will happily be inserted
> into committing_transaction's checkpoint list and do write-back work,
> then this buffer may be re-used as data-block, then there are two
> buffer_heads maps to the same block, buffer aliasing occurs, and we
> can't control the writeback order of the two buffer heads, fs may be
> inconsistent.
>      The same thing will happen if buffer_head doesn't belongs to
> running or committing transaction, but lays in checkpoint list.
>
> --
> =B6=A1=B6=A8=BB=AA
>



--=20
=B6=A1=B6=A8=BB=AA
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
