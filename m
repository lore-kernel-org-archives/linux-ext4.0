From: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Subject: [e2fsprogs PATCH] tune2fs: don't recover journal if
 device is busy.
Date: Mon, 12 Feb 2018 12:20:43 +1100
Message-ID: <871shrrok4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2060826517685730321=="
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lustre <lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
To: tytso-3s7WtUTddSA@public.gmane.org
Return-path: <lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
List-Unsubscribe: <http://lists.lustre.org/options.cgi/lustre-devel-lustre.org>,
 <mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.lustre.org/pipermail/lustre-devel-lustre.org/>
List-Post: <mailto:lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
List-Help: <mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.lustre.org/listinfo.cgi/lustre-devel-lustre.org>,
 <mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=subscribe>
Errors-To: lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org
Sender: "lustre-devel" <lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

--===============2060826517685730321==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


tune2fs currently replays the journal if it needs
recovery and the filesystem isn't mounted.

The test for "is the filesystem mounted" isn't completely robust.
Lustre makes use of ext4 filesystems in a way that they are mounted
without being visible in /proc/mounts or similar.
This usage can easily be detected by attempting to open the device
with O_EXCL.  tune2fs already does this and the EXT2_MF_BUSY flag
is set if open(O_EXCL) fails.
Several uses other than lustre mounts could cause O_EXCL to fail,
but in any case it seems unwise to recover the journal when something
else is keeping the device busy.

So add an extra test to avoid journal recovery when the device
is busy.  This fixes some problems with lustre usage.

Signed-off-by: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>

=2D-
Note: it seems wrong to recover the journal *after* making
changes to the superblock - there is a good chance that
recovering the journal will over-write those changes.
This is what was happening that lead me to this problem.
Shouldn't journal recovery happen *first*??

Thanks,
NeilBrown
=2D--
 misc/tune2fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index c33fb9d80b10..703e55b6b972 100644
=2D-- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -3337,7 +3337,7 @@ _("Warning: The journal is dirty. You may wish to rep=
lay the journal like:\n\n"
 	}
 #else
 	/* Recover the journal if possible. */
=2D	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & EXT2_MF_MOUNTED) &&
+	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & (EXT2_MF_BUSY | EXT2_MF=
_MOUNTED)) &&
 	    ext2fs_has_feature_journal_needs_recovery(fs->super)) {
 		errcode_t err;
=20
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqA6+sACgkQOeye3VZi
gbluZQ/+Pya8cz+6u1pdu8eQzShwomy4Xe9z9yFKYomYGQwiwNcyqv9eNNtQA3qm
xlNfynsBDQJXAZ/4d6PMBMpdnWHUtIPkBISRhpCwIeB2JkChf5hz4/T/A1rOvykx
uerUFJBBqMreH1NTqfW6kfHkscgHWZui4ng6pIUtox4O5lmI/ECvWx62EdozRvCu
96nYs6ewCfz1FwBs5pJ0YjGInIKd56L6RL721yHbyeG7LvKCrq6g7+UCK802s1E7
jsVoGuT/NmyO6JpCYYvnc7dBMk0LCLKaJylhWlqA4QWggUzJNQ8ExZlcSXNPC5+B
aO1qUdlqSpo0/1n4BRKfnjbR61qtyZAqoL/sWZDr3UGrS97WKVny+ysI/WucFmFN
kuQrMOGhW8pqyW3mvCfSnvzkLeE+T3MWRSAPoHC+bk6XG//X6tnW89lRNKox0XJB
lYRh7mGapMnUE3AahzDT9Cj/rn23AmQaKgyBWZkJPIMQosUjE0O2TAiybc8/7QeJ
6gmjn3LswM+mqjYpfgTp+XGTBZvcA+OWG1/BdjTRkMtHf45O1sQnXgC3znhSAiJ5
gfyCrXToo0SpI9Cb6IWtQT6JuRM0wRIK+Vvrk7O3CXg6WpCDl2bEl3GUKyc6/w1Z
nPzWU1j/HOEa++yYA1DVXHDLjS9kB4HZ9nFDJF+L1HX3IcP97HI=
=xkjP
-----END PGP SIGNATURE-----
--=-=-=--

--===============2060826517685730321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
lustre-devel mailing list
lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org
http://lists.lustre.org/listinfo.cgi/lustre-devel-lustre.org

--===============2060826517685730321==--
