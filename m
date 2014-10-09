From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] add aio/dio regression test race between write and fcntl V2
Date: Thu, 9 Oct 2014 23:35:14 +0800
Message-ID: <FF5595F9-86C3-44AD-87ED-EDBD6DB257AD@gmail.com>
References: <1412866642-25191-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:48157 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJIPfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2014 11:35:30 -0400
In-Reply-To: <1412866642-25191-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-10-09 22:57 GMT+08:00 Dmitry Monakhov
> Original report: https://lkml.org/lkml/2014/10/8/545
> perform AIO-DIO and fcntl(F_SETFL) concurently
> Unaligned AIO likely result in synchronization which makes racewindow=
 wider.
>=20
> changes from v1->v2
> - Properly reuse aio context
>=20
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> =E2=80=94

this test could not reproduce problem every time, but i could always pr=
oduce it
within 10 times,  after applying Ext4 kernel patch, tests passed after =
looping 100 times!

Tested-by: Wang Shilong <wangshilong1991@gmail.com


> src/aio-dio-regress/aio-dio-fcntl-race.c |  148 +++++++++++++++++++++=
+++++++++
> tests/generic/326                        |   51 ++++++++++
> tests/generic/326.out                    |    2 +
> tests/generic/group                      |    1 +
> 4 files changed, 202 insertions(+), 0 deletions(-)
> create mode 100644 src/aio-dio-regress/aio-dio-fcntl-race.c
> create mode 100755 tests/generic/326
> create mode 100644 tests/generic/326.out
>=20
> diff --git a/src/aio-dio-regress/aio-dio-fcntl-race.c b/src/aio-dio-r=
egress/aio-dio-fcntl-race.c
> new file mode 100644
> index 0000000..835dbdf
> --- /dev/null
> +++ b/src/aio-dio-regress/aio-dio-fcntl-race.c
> @@ -0,0 +1,148 @@
> +/*
> + * Perform aio writes to file and toggle O_DIRECT flag concurrently
> + * this may trigger race between file->f_flags read and modification
> + * unuligned aio allow to makes race window wider.
> + * Regression test for https://lkml.org/lkml/2014/10/8/545
> + *
> + * Copyright (C) 2010 Red Hat, Inc. All Rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-=
1307, USA.
> + */
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <libaio.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <time.h>
> +#include <sys/time.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +
> +#define BUF_SIZE	512
> +#define LOOP_SECONDS 10
> +
> +
> +static int do_aio_loop(int fd, void *buf)
> +{
> +	int err, ret;
> +	struct io_context *ctx =3D NULL;
> +	struct io_event ev;
> +	struct iocb iocb, *iocbs[] =3D { &iocb };
> +	struct timeval start, now, delta =3D { 0, 0 };
> +
> +	ret =3D 0;
> +	err =3D io_setup(1, &ctx);
> +	if (err) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(-err), "io_setup" );
> +		return 1;
> +	}
> +	while (1) {
> +		io_prep_pwrite(&iocb, fd, buf, BUF_SIZE, BUF_SIZE);
> +		err =3D io_submit(ctx, 1, iocbs);
> +		if (err !=3D 1) {
> +			fprintf(stderr, "error %s during %s\n",
> +				strerror(-err),
> +				"io_submit");
> +			ret =3D 1;
> +			break;
> +		}
> +		err =3D io_getevents(ctx, 1, 1, &ev, NULL);
> +		if (err !=3D 1) {
> +			fprintf(stderr, "error %s during %s\n",
> +				strerror(-err),
> +				"io_getevents");
> +			ret =3D 1;
> +			break;
> +		}
> +		gettimeofday(&now, NULL);
> +		timersub(&now, &start, &delta);
> +		if (delta.tv_sec >=3D LOOP_SECONDS)
> +			break;
> +	}
> +	io_destroy(ctx);
> +	return ret;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int flags, fd;
> +	int pid1, pid2 =3D 0;
> +	int ret1, ret =3D 0;
> +
> +	if (argc !=3D 2){
> +		printf("Usage %s fname\n", argv[0]);
> +		return 1;
> +	}
> +	fd =3D open(argv[1], O_CREAT | O_TRUNC | O_RDWR, 0600);
> +	if (fd < 0)
> +		return 1;
> +
> +	pid1 =3D fork();
> +	if (pid1 < 0)
> +		return 1;
> +
> +	if (pid1 =3D=3D 0) {
> +		struct timeval start, now, delta =3D { 0, 0 };
> +
> +		gettimeofday(&start, NULL);
> +
> +		/* child: toggle O_DIRECT*/
> +		flags =3D fcntl(fd, F_GETFL);
> +		while (1) {
> +			ret =3D fcntl(fd, F_SETFL, flags | O_DIRECT);
> +			if (ret)
> +				return ret;
> +			ret =3D fcntl(fd, F_SETFL, flags);
> +			if (ret)
> +				return ret;
> +
> +			gettimeofday(&now, NULL);
> +			timersub(&now, &start, &delta);
> +			if (delta.tv_sec >=3D LOOP_SECONDS)
> +				break;
> +		}
> +	} else {
> +		/* parent: AIO */
> +		void *buf;
> +		posix_memalign(&buf, BUF_SIZE, BUF_SIZE);
> +		/* Two tasks which performs unaligned aio will be serialized
> +		   which maks race window wider */
> +		pid2 =3D fork();
> +		if (pid2 < 0)
> +			goto out;
> +		else if (pid2 > 0)
> +			printf("All tasks are spawned\n");
> +
> +		ret =3D do_aio_loop(fd, buf);
> +	}
> +out:
> +	/* Parent wait for all others */
> +	if (pid2 > 0){
> +		waitpid(pid1, &ret1, 0);
> +		if (!ret)
> +			ret =3D ret1;
> +		waitpid(pid2, &ret1, 0);
> +	} else {
> +		waitpid(pid1, &ret1, 0);
> +	}
> +	if (!ret)
> +		ret =3D ret1;
> +
> +	return ret;
> +}
> diff --git a/tests/generic/326 b/tests/generic/326
> new file mode 100755
> index 0000000..8975a91
> --- /dev/null
> +++ b/tests/generic/326
> @@ -0,0 +1,51 @@
> +#! /bin/bash
> +# FS QA Test No. 326
> +#
> +# Run aio-dio-fcntl-race - test aio write race with O_DIRECT toggle
> +#
> +#-------------------------------------------------------------------=
----
> +# Copyright (c) 2009 Dmitry Monakhov.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundatio=
n,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-------------------------------------------------------------------=
----
> +#
> +
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +
> +_run_aiodio aio-dio-fcntl-race
> +
> +exit $status
> diff --git a/tests/generic/326.out b/tests/generic/326.out
> new file mode 100644
> index 0000000..a0c44b9
> --- /dev/null
> +++ b/tests/generic/326.out
> @@ -0,0 +1,2 @@
> +QA output created by 326
> +All tasks are spawned
> diff --git a/tests/generic/group b/tests/generic/group
> index 799bfd8..4aea4c6 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -151,3 +151,4 @@
> 323 auto aio stress
> 324 auto fsr quick
> 325 auto quick data log
> +326 auto quick aio rw stress
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
