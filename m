From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
Date: Fri, 17 Dec 2010 06:59:01 +0100
Message-ID: <1292565541.2655.28.camel@edumazet-laptop>
References: <20101121133024.GF23423@thunk.org>
	 <20101121153949.GD20947@barrios-desktop> <20101121173726.GG23423@thunk.org>
	 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
	 <rcu-radix-tree@mdm.bga.com> <20101122061619.GA2764@linux.vnet.ibm.com>
	 <1291748509.19276.62.camel@thinkpad>
	 <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
	 <1292507421.4885.19.camel@thinkpad>
	 <AANLkTinfTCpdKo-A8gF+xbss24PNQXvQV6Odh51mXxiH@mail.gmail.com>
	 <20101217054722.GG2253@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Minchan Kim <minchan.kim@gmail.com>, gerald.schaefer@de.ibm.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
	linux-mm@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ted Ts'o <tytso@mit.edu>, Arun Bhanu <ab@arunbhanu.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: paulmck@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39160 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0LQF7I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Dec 2010 00:59:08 -0500
In-Reply-To: <20101217054722.GG2253@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le jeudi 16 d=C3=A9cembre 2010 =C3=A0 21:47 -0800, Paul E. McKenney a =C3=
=A9crit :
> On Fri, Dec 17, 2010 at 09:04:13AM +0900, Minchan Kim wrote:
> > How about this?
> > Maybe Paul have better idea.
> > (It's apparently be word-wrapped.)
> >=20
> > diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.=
h
> > index ab2baa5..135af1e 100644
> > --- a/include/linux/radix-tree.h
> > +++ b/include/linux/radix-tree.h
> > @@ -146,6 +146,20 @@ static inline void *radix_tree_deref_slot(void=
 **pslot)
> >  }
> >=20
> >  /**
> > + * radix_tree_deref_slot_nocheck       - dereference a slot withou=
t RCU check
> > + * @pslot:     pointer to slot, returned by radix_tree_lookup_slot
> > + * Returns:    item that was stored in that slot with any direct p=
ointer flag
> > + *             removed.
> > + *
> > + * This functions works like radix_tree_deref_slot except it doesn=
't check
> > + * RCU rule. Normally this funcion is used with update-side lock.
> > + * You should use this function very carefully.
> > + */
> > +static inline void *radix_tree_deref_slot_nocheck(void **pslot)
> > +{
> > +       return rcu_dereference_protected(*pslot, 1);
>=20
> I suggest replacing the "1" with lockdep expressions for the locks
> that you say might be held:
>=20
> 	return rcu_dereference_check(*pslot,
> 				     lockdep_is_held(&mapping->tree_lock));
>=20

Yes, but point was also to use rcu_dereference_protected() here, not
rcu_dereference_check().



> This assumes that when you said "and" you meant both lock_page() and
> mapping->tree_lock.  Also you need to pass in the mapping, which
> should not be a problem given likely inlining.
>=20
> If you meant that either mapping->tree_lock or page_lock() might be
> held, I suppose that the page_lock() state could be passed in, but
> perhaps better to take a general lockdep expression.
>=20
> So, either or both?  ;-)
>=20

Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
