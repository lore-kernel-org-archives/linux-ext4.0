From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Date: Wed, 7 Sep 2011 01:44:58 +0900
Message-ID: <20110906164458.GI18425@mtj.dyndns.org>
References: <20110826072622.406d3395@kryten>
 <20110826072927.5b4781f9@kryten>
 <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110829214609.495ee299@kryten>
 <20110906034851.GC18425@mtj.dyndns.org>
 <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anton Blanchard <anton@samba.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61786 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1IFQpL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Sep 2011 12:45:11 -0400
Content-Disposition: inline
In-Reply-To: <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 06, 2011 at 09:30:50AM -0400, Theodore Tso wrote:
> >> I chose to cap percpu_counter_batch at 1024 as a conservative firs=
t
> >> step, but we may want to reduce it further based on further benchm=
arking.
> >>=20
> >> Signed-off-by: Anton Blanchard <anton@samba.org>
> >=20
> > Applied to percpu/for-3.2.
>=20
> Um, this was an ext4 patch and I pointed out it could cause problems.=
  (Specifically, data loss=E2=80=A6)

Ah okay, I thought you were talking about the first patch only.
Reverting for now.

Thanks.

--=20
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
