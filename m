From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Re: [Ocfs2-devel] [PATCH] OCFS2: Allow huge (> 16 TiB) volumes to
	mount
Date: Tue, 6 Jul 2010 17:13:27 -0700
Message-ID: <AANLkTilgO6V0ugvm3vvI5sHNC3zNxYa1zu_VxjCSoVIg@mail.gmail.com>
References: <87mxud74tw.fsf@gmail.com>
	<20100706200438.GF17961@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51396 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0GGAN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2010 20:13:28 -0400
In-Reply-To: <20100706200438.GF17961@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 6, 2010 at 1:04 PM, Joel Becker <Joel.Becker@oracle.com> wr=
ote:
>
> Thus, I propose the following jbd2 patch. =A0jbd2 people, what do you
> think:
>
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index bc2ff59..7922d87 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t
> *journal,
>
> =A0 =A0 =A0 =A0if (!compat && !ro && !incompat)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> + =A0 =A0 =A0 if (journal_get_superblock(journal))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0
> =A0 =A0 =A0 =A0if (journal->j_format_version =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;

As an alternative, could jbd2_journal_init_inode() just call
journal_get_superblock() itself?  That would naturally make the
feature bits valid as soon as the journal is initialized.  It would
also preserve all error checking, instead of converting superblock
read errors into "this journal has no features".

JBD2 developers, please advise.  OCFS2 needs to examine JBD2 journal
feature bits *before* the journal is recovered, which is not possible
at present.  What is the best approach to fixing this?

Thanks.

 - Pat
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
