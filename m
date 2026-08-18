Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E416E374E42
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 22:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787093081; cv=none; b=ujWSO3ni89efdYBAVNQbZR7+BnfuknnsnwYdjV3QpYt9ZHhq9qVZdv5Md4JHzqjLcxZBO4ctAMzBi30FR+HHu0eMB1t70AuVu9WIzY4E1d2znArtGWSCrPWtGiE2Q0mqms8NdfAzQtvDjDIycBOdxEN2p1DGwEEufiPXg7lUPt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787093081; c=relaxed/simple;
	bh=bWmQQbj116ccIjQYtDxpc0TzI2hjcFc/UFah7b+KgF0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=V6qvB0eXIqKITHcq1waK7tNmSz8V3BY5di0YBLJTM2YmZsauXiekQ7WNrWlDd3K0aDrbWHLGUGIne1irQr0ztZT/YNCcSs2Og5ufiWDPF+CKrjkx8eCG68yxudkwpptDmw/hFUlbap1aVAj6kYPx8gbGna4rb4hrTU+u3qpD1EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=d/c6tkJ/; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="d/c6tkJ/"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38759bcd877so573738a91.2
        for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 15:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1787093078; x=1787697878; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xcq/OQr5mxJRiHZfYmIiC1rWacqQGUo+VGDkflEWguk=;
        b=d/c6tkJ/tdyNvV/zdVsc+nGGTbJx5kbyYeghsjQgaMfAEeSIapwj4LqZErF47bI1RY
         6H0M3cXbGGTUUHDCSpe1rXPELYO8ytzf+X9CMc9Dws3r3Pls6vAk8CHKFXs6MdAMiCz5
         iVrBb7VH4QXQ7/6VuLnn6BiL2m62pOrAoURPHZP64gb9tU6omBWJaPtOeIXrnJdO25Cw
         RKDaxDlz9DVolq6/g2rcqOPk5Py9lWbSK8DfRlP6PFFSevJpA3avuOaRD5qcV95Itnyx
         Pp43HrEP4yNG8KaFmd+Dr8+irvy5j0RMwp3Iz9xIdYfh4guccyPbw/tv+X6TgqfYZQRE
         a1Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787093078; x=1787697878;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xcq/OQr5mxJRiHZfYmIiC1rWacqQGUo+VGDkflEWguk=;
        b=ZiFICRYJPPdzreNtoV7HaTmXLhAZ9C6MJO4AF3tqLw83vtFC/QSfcZGM/MOmLmN3Rp
         MxVkYpNKQWdvKINkoXmaGg6MZXCYEu96n42IW0GxadZmotmXqSYyGZ4SAfps7Kjswqda
         r4zFvayS0/UUJgPoyr4luvBfDhqx+sTxqztw2e2RqJKjALi537l9o7Y0lRRDUwqK7mQU
         L10u0GsyvdQHnCc/En7zzsvMpulynSGftWDgNkXfYUSaE4sohei8aTZaUSGnKKXDD31I
         HzHBvDlcfWQV5nKKZrXKSpWGatR9F3fKuJpmd0tUcUQMl/DwEAPP2b741G6ut5zXAzf+
         FnZQ==
X-Forwarded-Encrypted: i=1; AHgh+RomkD2OHFXVbjetQPqpPVlpaPgpGX1ft9QKXkzkiKJJs0zZxgApkSOao9xHemZ6AGjqr1JDKDRA2Dra@vger.kernel.org
X-Gm-Message-State: AOJu0YyAmnH6ZziWSlIasVcMI89UyMlaEpojPwDlTrwaSyzy3GB28z8G
	uevAhQ3WU7oCkNMJnpm6SH56TCXp52Y5a7NEF5Lv95iUkC7E93ov/p4R3Sdrd5lqVcs=
X-Gm-Gg: AR+sD12gPOD+ETkbZsPoTtkoIB1z71JCEsNWBzg/5S+geqhnhrhgZayFJ0TBXcQZgo0
	IhYqmsJgudy50jY+McJmGpv/eTEVwDmHz6f6TOA1V1MlpcIp729VQS6A8tQGATJeAjEDK/EVBAS
	b+x2csl2UNpu7A8CgWf/sOX9jj/IMunVmXTQMsaU7e2qRlAFwbfZRgDRak60u5gqgljrrgAjj9N
	LWKwFrsRbhwbmz0WOIjlw0sFofasVcPZQespHBSyiTeij2ihztXLC8MW7rCj85qMS2c9Bfhxm54
	kycg14XrPJQGLNB4ej5SJz1+NUkF/2rjala6tW6OWkjPr+KK33AvP0UEQ9XvRR6eGBiGvV9fOJL
	C8Ae8dJTF1DMLRCBbqDFrkU8iuyQfvwJI0griJh3L+qtUMo+A5fKCm77Vay1P8VhZr2ByR+HCWv
	2O/86UcajsMk23Oi7+pnNYo0jUsp/Y3A62lVr+emSzl8w740mH++EJMAhzwf6zDZHG7b1aNB/wG
	CsjkBJ72FE+TcHUfA==
X-Received: by 2002:a17:90b:3d85:b0:38f:7f60:ba35 with SMTP id 98e67ed59e1d1-39580f04a31mr450506a91.5.1787093078056;
        Tue, 18 Aug 2026 15:44:38 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:116b:5080:33ad:e648])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm302974a91.2.2026.08.18.15.44.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 15:44:37 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] e2fsck: take flock(LOCK_EX) on whole-disk device during
 filesystem check
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <an/5Oj5mb/S1ekb8@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Date: Tue, 18 Aug 2026 16:44:26 -0600
Cc: tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 srivatsa@csail.mit.edu
Content-Transfer-Encoding: quoted-printable
Message-Id: <E687B950-B823-436E-BB3A-E6C7E87CC3C7@dilger.ca>
References: <20260720143246.4141501-1-naraghavan@linux.microsoft.com>
 <an/5Oj5mb/S1ekb8@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
To: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Aug 14, 2026, at 23:29, Nandakumar Raghavan =
<naraghavan@linux.microsoft.com> wrote:
>=20
> Hi,
>=20
> Gentle ping on this patch.
>=20
> I would appreciate any feedback when time permits.
>=20
> On Mon, Jul 20, 2026 at 02:32:46PM +0000, Nandakumar Raghavan wrote:
>> During journal replay, e2fsck writes the primary superblock back to =
disk
>> in multiple I/O operations. The payload lands before the checksum, =
leaving
>> a transient window where the on-disk superblock has a bad checksum.
>>=20
>> If udevd processes a change uevent during this window, libblkid =
probes the
>> primary superblock, finds a checksum mismatch, and concludes the =
partition
>> has no recognisable filesystem. udev then fires a remove event, =
wiping all
>> symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount =
unit
>> that depends on those symlinks will fail.
>>=20
>> udevd already serialises its own partition probes against whole-disk =
device
>> access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it =
requeues the
>> event. Take advantage of this protocol by acquiring flock(LOCK_EX) on =
the
>> whole-disk device before opening the filesystem. This forces udevd to =
defer
>> all probes on that disk until e2fsck exits and the lock is released, =
by
>> which point the filesystem is fully consistent.
>>=20
>> The whole-disk device is resolved via sysfs =
(/sys/dev/block/MAJ:MIN/partition)
>> so that the lock covers the same device node that udevd locks. If =
sysfs
>> resolution fails, a warning is emitted and the lock falls back to the
>> partition device itself.
>>=20
>> Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>

This looks like it would unnecessarily emit an error message if run on =
any
non-Linux platform (e.g. MacOS, BSD), so it needs to be conditionally =
built.

>> ---
>> e2fsck/unix.c | 105 =
++++++++++++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 105 insertions(+)
>>=20
>> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
>> index 335ca377..12a9f50a 100644
>> --- a/e2fsck/unix.c
>> +++ b/e2fsck/unix.c
>> @@ -36,6 +36,15 @@ extern int optind;

Presumably this code is only useful on Linux, so the conditional headers =
are not needed,
only a single `#ifdef __linux__`?  Not really critical either way.

>> #ifdef HAVE_SYS_IOCTL_H
>> #include <sys/ioctl.h>
>> #endif
>> +#ifdef HAVE_SYS_FILE_H
>> +#include <sys/file.h>
>> +#endif
>> +#ifdef HAVE_SYS_STAT_H
>> +#include <sys/stat.h>
>> +#endif
>> +#ifdef HAVE_SYS_SYSMACROS_H
>> +#include <sys/sysmacros.h>
>> +#endif
>> #ifdef HAVE_MALLOC_H
>> #include <malloc.h>
>> #endif
>> @@ -1397,6 +1406,92 @@ err:
>> +static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)

This function should similarly be #ifdef'd out if not building on Linux.

>> +{
>> + 	struct stat st;
>> + 	char partition_attr[256];  /* sysfs 'partition' attribute path =
*/
>> + 	char parent_dev_path[256]; /* sysfs '../dev' of the parent disk =
*/
>> + 	char parent_devnum[32];
>> + 	FILE *f;
>> + 	unsigned int maj, min;
>> + 	int parent_resolved =3D 0;
>> + 	char lock_path[256];
>> + 	const char *opened_path;
>> + 	int fd;
>> +
>> + 	if (stat(dev_name, &st) < 0)
>> + 		return -1;
>> +
>> + 	if (!S_ISBLK(st.st_mode))
>> + 		return -1;
>> +
>> + 	maj =3D major(st.st_rdev);
>> + 	min =3D minor(st.st_rdev);
>> +
>> + 	/*
>> +	 * If dev_name is a partition (sysfs 'partition' attribute =
exists),
>> +	 * resolve the parent whole-disk device so the flock covers the =
same
>> +	 * device node that udevd locks before probing any partition on =
it.
>> +	 */
>> + 	snprintf(partition_attr, sizeof(partition_attr),
>> + 		 "/sys/dev/block/%u:%u/partition", maj, min);
>> +
>> + 	if (access(partition_attr, F_OK) =3D=3D 0) {
>> + 		snprintf(parent_dev_path, sizeof(parent_dev_path),
>> + 			 "/sys/dev/block/%u:%u/../dev", maj, min);

(minor) this could reuse `partition_attr` here?

>> +		f =3D fopen(parent_dev_path, "r");
>> +		if (f) {
>> + 			if (fscanf(f, "%31s", parent_devnum) =3D=3D 1) {
>> +				 unsigned int pmaj, pmin;
>> +				 if (sscanf(parent_devnum, "%u:%u",
>> +					    &pmaj, &pmin) =3D=3D 2) {
>> + 					maj =3D pmaj;
>> +					min =3D pmin;
>> + 					parent_resolved =3D 1;
>> + 				}
>> +			}
>> + 			fclose(f);
>> + 		}
>> +		if (!parent_resolved)
>> +			 log_err(ctx, _("Warning: could not resolve =
whole-disk "
>> +				        "device for %s; lock may not =
prevent "
>> +				        "udev races\n"), dev_name);
>> +	}
>> +
>> + 	snprintf(lock_path, sizeof(lock_path),
>> + 		 "/dev/block/%u:%u", maj, min);

(style) could fit on a single line?

(style) could re-use `partition_attr` here (maybe renamed to `dev_path` =
or similar)
to avoid having 3 single-use pathnames on the stack.

>> +
>> +	opened_path =3D lock_path;
>> + 	fd =3D open(lock_path, O_RDONLY | O_CLOEXEC, 0);
>> + 	if (fd < 0) {
>> + 		fd =3D open(dev_name, O_RDONLY | O_CLOEXEC, 0);
>> + 		if (fd < 0)
>> + 			return -1;
>> + 		opened_path =3D dev_name;
>> + 		if (parent_resolved)
>> + 			log_err(ctx, _("Warning: %s not found; locking =
%s "
>> +				       "instead, lock may not prevent "
>> +				       "udev races\n"), lock_path, =
dev_name);

(style) shouldn't split error messages across lines, even if > 80 =
columns

>> +	}
>> +
>> + 	while (flock(fd, LOCK_EX) !=3D 0) {
>> + 		if (errno =3D=3D EINTR) {
>> + 			if (ctx->flags & E2F_FLAG_CANCEL) {
>> + 				close(fd);
>> + 				return -1;
>> + 			}
>> + 			continue;

Does this loop/hang forever if you try to kill it with CTRL-C?

>> + 		}
>> + 		com_err(ctx->program_name, errno,
>> + 			_("while trying to lock %s"), opened_path);
>> + 		close(fd);
>> +		return -1;
>> +	}
>> +
>> + 	return fd;
>> +}
>> +
>> int main (int argc, char *argv[])
>> {
>> errcode_t retval =3D 0, retval2 =3D 0, orig_retval =3D 0;
>> @@ -1413,6 +1508,7 @@ int main (int argc, char *argv[])
>> int journal_size;
>> int sysval, sys_page_size =3D 4096;
>> int old_bitmaps;
>> + int lock_fd =3D -1;
>> __u32 features[3];
>> char *cp;
>> enum quota_type qtype;
>> @@ -1488,6 +1584,12 @@ int main (int argc, char *argv[])
>>=20
>> check_mount(ctx);
>>=20
>> + lock_fd =3D lock_whole_disk(ctx, ctx->filesystem_name);
>> + if (lock_fd < 0)
>> + log_err(ctx, _("Warning: could not lock %s; "
>> +       "proceeding without block device lock\n"),
>> + ctx->filesystem_name);
>> +
>> if (!(ctx->options & E2F_OPT_PREEN) &&
>>    !(ctx->options & E2F_OPT_NO) &&
>>    !(ctx->options & E2F_OPT_YES)) {
>> @@ -2169,6 +2271,9 @@ skip_write:
>> ext2fs_close_free(&ctx->fs);
>> free(ctx->journal_name);
>>=20
>> + if (lock_fd >=3D 0)
>> + close(lock_fd);
>> +
>> if (ctx->logf)
>> fprintf(ctx->logf, "Exit status: %d\n", exit_value);
>> e2fsck_free_context(ctx);
>> --=20
>> 2.54.0
>=20


Cheers, Andreas





