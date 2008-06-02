From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Test results for ext4
Date: Mon, 02 Jun 2008 15:44:04 +0200
Message-ID: <4843F924.1050109@bull.net>
References: <48402253.8040407@bull.net> <20080530131239.6d93f1d9@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48087 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYFBNoZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 09:44:25 -0400
In-Reply-To: <20080530131239.6d93f1d9@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jose R. Santos wrote:
>         agefs=3D1
>         [threadgroup0]
>                 num_threads=3D10
>                 write_size=3D40960
>                 write_blocksize=3D4096
>                 create_weight=3D10
>                 append_weight=3D10
>                 delete_weight=3D1
>         [end0]
>                 desired_util=3D0.80
>=20
> This will age the filesystem until it reaches 80% utilization before
> starting the benchmark.  Since a 5TB disk will take a while to age, I
> suggest trying this on just a few runs.
Ok to do it only on a few runs (creating a 4TB file on my device takes
more than 12 hours...)
   Val=C3=A9rie
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
