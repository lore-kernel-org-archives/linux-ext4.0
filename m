From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] JBD2: Allow feature checks before
	journal recovery
Date: Wed, 21 Jul 2010 19:50:24 +0200
Message-ID: <20100721175024.GF1215@atrey.karlin.mff.cuni.cz>
References: <871vbax86w.fsf@patl.com>
	<20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
	<AANLkTikdCRfgDRLHZ7zr-ZALU8g8LwWc5We-CgbcQ8mF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <AANLkTikdCRfgDRLHZ7zr-ZALU8g8LwWc5We-CgbcQ8mF@mail.gmail.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

> On Wed, Jul 21, 2010 at 10:27 AM, Jan Kara <jack@suse.cz> wrote:
> >> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> >>
> >> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> >> index bc2ff59..c5a864f 100644
> >> --- a/fs/jbd2/journal.c
> >> +++ b/fs/jbd2/journal.c
> >> @@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t =
*journal, unsigned long compat,
> >>
> >> =A0 =A0 =A0 if (!compat && !ro && !incompat)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> >> + =A0 =A0 if (journal_get_superblock(journal))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> =A0 =A0 =A0 if (journal->j_format_version =3D=3D 1)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >
> > This looks OK in principle. It would be even nicer to avoid all the che=
cks
> > journal_get_superblock() when the superblock is actually loaded so that=
 we
> > don't do them each time jbd2_journal_check_used_features is called...
> =

> How about this?
> =

>          if (!compat && !ro && !incompat)
>                 return 1;
> +        if (journal->j_format_version =3D=3D 0 &&
> journal_get_superblock(journal) !=3D 0)
> +               return 0;
>         if (journal->j_format_version =3D=3D 1)
>                 return 0;
> =

> journal_init_common() uses kzalloc() to allocate the journal_t, and
> journal_get_superblock() fills it in, so I believe this is a valid
> test.
  Yes, this looks OK. Just add a comment before the check like
/* Load journal super block if it isn't loaded yet */

								Honza
-- =

Jan Kara <jack@suse.cz>
SuSE CR Labs
