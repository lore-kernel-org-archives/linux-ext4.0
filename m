From: Andreas Dilger <adilger@dilger.ca>
Subject: Corruption from interrupted e2fsck
Date: Sun, 1 Nov 2015 18:16:50 -0700
Message-ID: <B9F63236-3539-492E-83EB-3377836C2FDB@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_7D389006-C92D-47C9-92DF-BBC4226FEE0F"; protocol="application/pgp-signature"; micalg=pgp-sha256
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35258 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbKBBQ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Nov 2015 20:16:56 -0500
Received: by pasz6 with SMTP id z6so130403595pas.2
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2015 17:16:56 -0800 (PST)
Received: from cabot-wlan.adilger.int (S0106002191d9348b.cg.shawcable.net. [96.51.76.157])
        by smtp.gmail.com with ESMTPSA id ir4sm20419463pbb.93.2015.11.01.17.16.54
        for <linux-ext4@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Nov 2015 17:16:55 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_7D389006-C92D-47C9-92DF-BBC4226FEE0F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

It looks there is a bug in how e2fsck handles being interrupted by =
CTRL-C.
If CTRL-C is pressed to kill e2fsck rather than e.g. kill -9, then the
interrupt handler sets E2F_FLAG_CANCEL in the context but doesn't =
actually
kill the process.  Instead, e2fsck_pass1() checks this flag before =
processing
the next inode.

If a filesystem is running in fix mode (e2fsck -fy) is interrupted, and =
the
quota feature is enabled, then the quota file will still be written to =
disk
even though the inode scan was not complete and the quota information is
totally inaccurate.  Even worse, if the Pass 1 inode and block scan was =
not
finished, then the in-memory block bitmaps (which are used for block
allocation during e2fsck) are also invalid, so any blocks allocated to =
the
quota files may corrupt other files if those blocks were actually used.

It also looks like the journal may also be recreated after e2fsck is
interrupted, if it was deleted during pass 1 because of corruption.

static void signal_cancel(int sig EXT2FS_ATTR((unused)))
{
        e2fsck_t ctx =3D e2fsck_global_ctx;

        if (!ctx)
                exit(FSCK_CANCELED);

        ctx->flags |=3D E2F_FLAG_CANCEL;
}


	sa.sa_handler =3D signal_cancel;
	sigaction(SIGINT, &sa, 0);
	sigaction(SIGTERM, &sa, 0);
	:
	:
        run_result =3D e2fsck_run(ctx);
        e2fsck_clear_progbar(ctx);

        if (!ctx->invalid_bitmaps &&
            (ctx->flags & E2F_FLAG_JOURNAL_INODE)) {
		if (fix_problem(ctx, PR_6_RECREATE_JOURNAL, &pctx)) {
			:
			:
			retval =3D ext2fs_add_journal_inode(fs, =
journal_size, 0);
		}
	}

no_journal:
	if (ctx->qctx) {
		for (i =3D 0; i < MAXQUOTAS; i++) {
			retval =3D quota_compare_and_update(ctx->qctx, =
i, &needs_writeout);
		}
	}

	if (run_result & E2F_FLAG_ABORT)
		fatal_error(ctx, _("aborted"));

Is there a reason not to have a cancel check right after the return from
e2fsck_run() rather than trying to recover the journal and quota files?
I can imagine that there is a desire to flush out modified inodes and =
such
that have been repaired, so that restarting an interrupted e2fsck will =
make
progress, but the quota file update is plain wrong unless at least pass1
has finished, and the journal recreation is also dangerous if the block
bitmaps have not been fully updated.

The quota problem was hit in on a system, but the journal problem is =
only a
theory at this point.  I'm working on a patch but wanted to solicit =
input in case there is something that I'm missing.

Cheers, Andreas






--Apple-Mail=_7D389006-C92D-47C9-92DF-BBC4226FEE0F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVja5g3Kl2rkXzB/gAQjLTQ/+KR6TJLDELD5H8giWuRgAzdpy4q2KtIi8
rUZWoDQoHgTjt+p4weSYMSQrrqI7bpzi2Wggwe6s8uHets2TelnQfnWKwyuWduIG
AE3KxUcwNnpB8lRu6I928yz7qtgH39gd/ctiWMcXhbXzDnlTWdb52FYBwX8/stsP
FBEblDUn7M3knETqDqE5SvkEJ+VBrWaBkOtjIxt6Ds3Yoa+ZItnxc+yrKrSuYpGz
meqmalVPhBIFn81GHJFnkmWYxNsGdFMG7QfJIKyTvYY9edNnQ3aTPVQf3YSZ6HJ0
os1sfXDnu09E8NmQFqOnUPwxpvau4ayByNZUIvw56RvaL5gxz5xy0Hu0d05gE0Ms
tHlM1t+cMaOBreTfryB4SaGTF6wstoqrrjUjGDIDtN2yz56r5Ky8hvlEh322PseV
oPp258dJszOnOPckDTXnKmEf4XPotIouqvIIfO7pKmNKrajvZjmY8v0jSKT81MUZ
B3l2d4vfUrko0cnjEO47sBXLrGpUUNY5LrsztqHWCucd/zY0SomgkrgeWyTzj740
JZvgub1boKOSxbCuDzhGCkJJpy5QDnoWU32+Vo4BIoDFvOLu5MY6j84xmdjXj21t
WV/uq7+Uv5PZ8oqIl70X0WU6/FG/WXeyMdVoLQKMAjPZsLdDKOc0D4WuswIpir99
hmKEn5swe8o=
=NuOC
-----END PGP SIGNATURE-----

--Apple-Mail=_7D389006-C92D-47C9-92DF-BBC4226FEE0F--
