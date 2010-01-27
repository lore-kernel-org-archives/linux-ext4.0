From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: journal forget may introduce buffer aliasing problem?
Date: Wed, 27 Jan 2010 11:44:08 +0800
Message-ID: <7bb361261001261944v7b5d698bn9da51d1f418c1594@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f173.google.com ([209.85.223.173]:57001 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0A0DoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jan 2010 22:44:09 -0500
Received: by iwn3 with SMTP id 3so1131707iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 19:44:08 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all:
       The following is my analysis(if wrong, please point it out),
may be I can send a patch out if it's a bug.
       If buffer_head belongs to comitting transaction,
jbd2_journal_forget do nothing except discard it from running
transaction. So this buffer will happily be inserted
into committing_transaction's checkpoint list and do write-back work,
then this buffer may be re-used as data-block, then there are two
buffer_heads maps to the same block, buffer aliasing occurs, and we
can't control the writeback order of the two buffer heads, fs may be
inconsistent.
      The same thing will happen if buffer_head doesn't belongs to
running or committing transaction, but lays in checkpoint list.

--=20
=B6=A1=B6=A8=BB=AA
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
