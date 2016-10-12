From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
Date: Wed, 12 Oct 2016 16:58:35 -0600
Message-ID: <FB6D02AD-62D8-4D29-81DF-B8BF81BD5FAC@dilger.ca>
References: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_50CEA410-1BA0-46BA-A9B6-C718F8516849"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, taesoo@gatech.edu,
        changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
        csong84@gatech.edu, stable@vger.kernel.org,
        "Faccini, Bruno" <bruno.faccini@intel.com>
To: Taesoo Kim <tsgatesv@gmail.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_50CEA410-1BA0-46BA-A9B6-C718F8516849
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Mar 17, 2015, at 8:08 PM, Taesoo Kim <tsgatesv@gmail.com> wrote:
> 
> When 'jh->b_transaction == transaction' (asserted by below)
> 
>         J_ASSERT_JH(jh, (jh->b_transaction == transaction || ...
> 
> 'journal->j_list_lock' will be incorrectly unlocked, since
> spin_lock() is called only in the 'if' and 'else-if' blocks but
> not in the missing 'else' case, which results in a hang or an oops:
> 
>     ------------[ cut here ]------------
>     kernel BUG at fs/jbd2/transaction.c:2239!
>     invalid opcode: 0000 [#1] SMP
>     RIP: 0010: __jbd2_journal_file_buffer+0x206/0x220 [jbd2]
>     Call Trace:
>     do_get_write_access+0x33c/0x4e0 [jbd2]
>     jbd2_journal_get_write_access+0x27/0x40 [jbd2]
>     __ext4_journal_get_write_access+0x3b/0x80 [ext4]
>     ext4_delete_entry+0xa9/0x1a0 [ext4]
>     ext4_unlink+0x600/0xa90 [ext4]
> 
> which is assert_spin_locked(&transaction->t_journal->j_list_lock).
> 
> Move spin_unlock() into the two cases where it is actually locked.
> 
> Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>

We've hit this repeatedly on kernels with commit v3.14-rc2-30-g6e4862a
"jbd2: minimize region locked by j_list_lock in journal_get_create_access"
under heavy load and this patch has fixed the problem.

It should also be considered for stable kernels after 3.14.

[I've updated the above commit message slightly to give more details.]

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/jbd2/transaction.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 5f09370..edb7f59 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1091,6 +1091,7 @@ int jbd2_journal_get_create_access(handle_t
>  		JBUFFER_TRACE(jh, "file as BJ_Reserved");
>  		spin_lock(&journal->j_list_lock);
>  		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
> +		spin_unlock(&journal->j_list_lock);
>  	} else if (jh->b_transaction == journal->j_committing_transaction) {
>  		/* first access by this transaction */
>  		jh->b_modified = 0;
> @@ -1098,8 +1099,8 @@ int jbd2_journal_get_create_access(handle_t
>  		JBUFFER_TRACE(jh, "set next transaction");
>  		spin_lock(&journal->j_list_lock);
>  		jh->b_next_transaction = transaction;
> +		spin_unlock(&journal->j_list_lock);
>  	}
> -	spin_unlock(&journal->j_list_lock);
>  	jbd_unlock_bh_state(bh);
> 
>  	/*
> --
> 2.3.3


Cheers, Andreas






--Apple-Mail=_50CEA410-1BA0-46BA-A9B6-C718F8516849
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV/7AHHKl2rkXzB/gAQgogg/9H7D1DCtlinV1oKMj/EgrtX2hdQEioPHj
oXNAob/ULFTqsn2RiWuZWxuvXwEjG34wB8ottPkGZl8+5SArAk7zf20RLFJ3quEn
jky2Zm3TAtYCzA6bv8CFYZwXWt8VvFR08EcGUpohfZJpStGWSshs4B669CktCH5z
YlfR+zYCr958vxEjAHZVubS51ij9m8G2QNx0jSu3d7Y2bFBHzBCZN7EOm6a5A4AC
ms+5cDpI1kxkRyE5xOESlisVInY4dDtpDQbOpTnSK85TRpWTpBRABaPqSMYtnIxR
9Bq94Y5lt+dLRmvc2LrnCOF7pghIhPIlNxuY2BxMpmUWXADchNozRllJ87cipEQM
zKlfeYirWI9jTVe7etfsUDGsegkyp3SftPn9UPdMhe7lI+0WNI32r87adPMlkR6i
gPvPJMfLJnAWSRz7tWvnKy3mwWJ1HYda49xeJcmETa08fjo2H83FJu4Hy99TUh5q
l6Z3tqBGBXGPRvmdgAJsurauaZDyN6OAMR0/qvH24NoGy4YoX/OhO4I95z/kyz/a
uCZO8OuiNNLrygy37b2HcZ++mkXcqrSp5bL1K44md1TCPUSXnu06Fvxj+snL7FoH
06jEV1HtxCSXk6hw547H+7fSwKjpdAjd9Im4wtholACc34kMJLqTDIjn+A322dTf
jjhbNinck08=
=GolN
-----END PGP SIGNATURE-----

--Apple-Mail=_50CEA410-1BA0-46BA-A9B6-C718F8516849--
