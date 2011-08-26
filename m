From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Date: Fri, 26 Aug 2011 10:39:43 +0200
Message-ID: <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110826072622.406d3395@kryten>
	 <20110826072927.5b4781f9@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, tj@kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60116 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1HZIjo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 04:39:44 -0400
In-Reply-To: <20110826072927.5b4781f9@kryten>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le vendredi 26 ao=C3=BBt 2011 =C3=A0 07:29 +1000, Anton Blanchard a =C3=
=A9crit :

> +/*
> + * We set the batch at 2 * num_online_cpus(), with a minimum of 32 a=
nd
> + * a maximum of 1024.
> + */
>  static void compute_batch_value(void)
>  {
>  	int nr =3D num_online_cpus();
> =20
> -	percpu_counter_batch =3D max(32, nr*2);
> +	percpu_counter_batch =3D min(1024, max(32, nr*2));
>  }
> =20
>  static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_=
block *nb,

Or use the following :

percpu_counter_batch =3D clamp(nr*2, 32, 1024);



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
