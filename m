From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Date: Wed, 7 Sep 2011 21:08:55 +1000
Message-ID: <20110907210855.414d417e@kryten>
References: <20110826072622.406d3395@kryten>
	<20110826072927.5b4781f9@kryten>
	<1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20110829214609.495ee299@kryten>
	<20110906034851.GC18425@mtj.dyndns.org>
	<EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:56420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1IGRFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Sep 2011 13:05:13 -0400
In-Reply-To: <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

> Um, this was an ext4 patch and I pointed out it could cause
> problems.  (Specifically, data loss=E2=80=A6)

I'm a bit confused. While the comment mentions ext4, the patch is just
putting an upper bound on the size of percpu_counter_batch and it is
useful for percpu_counter_compare() too:

 static void compute_batch_value(void)
 {
        int nr =3D num_online_cpus();

-       percpu_counter_batch =3D max(32, nr*2);
+       /*
+        * The cutoff point for the percpu_counter_compare() fast path =
grows
+        * at num_online_cpus^2 and on a big enough machine it will be
+        * unlikely to hit.
+        * We clamp the batch value to 1024 so the cutoff point only gr=
ows
+        * linearly past 512 CPUs.
+        */
+       percpu_counter_batch =3D clamp(nr*2, 32, 1024);
 }

The batch value should be opaque to the rest of the kernel. If ext4
requires a specific batch value we can use the functions that take
an explicit one (eg __percpu_counter_add).

Anton
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
