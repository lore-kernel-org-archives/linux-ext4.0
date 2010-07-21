From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Re: [PATCH 1/2] JBD2: Allow feature checks before journal recovery
Date: Wed, 21 Jul 2010 10:42:51 -0700
Message-ID: <AANLkTikdCRfgDRLHZ7zr-ZALU8g8LwWc5We-CgbcQ8mF@mail.gmail.com>
References: <871vbax86w.fsf@patl.com>
	<20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44601 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0GURmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jul 2010 13:42:53 -0400
In-Reply-To: <20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 21, 2010 at 10:27 AM, Jan Kara <jack@suse.cz> wrote:
>> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index bc2ff59..c5a864f 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_=
t *journal, unsigned long compat,
>>
>> =A0 =A0 =A0 if (!compat && !ro && !incompat)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 if (journal_get_superblock(journal))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (journal->j_format_version =3D=3D 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> This looks OK in principle. It would be even nicer to avoid all the c=
hecks
> journal_get_superblock() when the superblock is actually loaded so th=
at we
> don't do them each time jbd2_journal_check_used_features is called...

How about this?

         if (!compat && !ro && !incompat)
                return 1;
+        if (journal->j_format_version =3D=3D 0 &&
journal_get_superblock(journal) !=3D 0)
+               return 0;
        if (journal->j_format_version =3D=3D 1)
                return 0;

journal_init_common() uses kzalloc() to allocate the journal_t, and
journal_get_superblock() fills it in, so I believe this is a valid
test.

 - Pat
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
