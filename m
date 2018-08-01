From: Florian Westphal <fw@strlen.de>
Subject: Re: SLAB_TYPESAFE_BY_RCU without constructors (was Re: [PATCH v4
 13/17] khwasan: add hooks implementation)
Date: Wed, 1 Aug 2018 13:40:48 +0200
Message-ID: <20180801114048.ufkr7zwmir7ps3vl@breakpoint.cc>
References: <e3b48104-3efb-1896-0d46-792419f49a75@virtuozzo.com>
 <01000164f169bc6b-c73a8353-d7d9-47ec-a782-90aadcb86bfb-000000@email.amazonses.com>
 <CA+55aFzHR1+YbDee6Cduo6YXHO9LKmLN1wP=MVzbP41nxUb5=g@mail.gmail.com>
 <CA+55aFzYLgyNp1jsqsvUOjwZdO_1Piqj=iB=rzDShjScdNtkbg@mail.gmail.com>
 <CACT4Y+aYZumcc-Od5T1AnP4mwn8-FaWfxvfb93MnNwQPqG8TDw@mail.gmail.com>
 <CACT4Y+ZkgqDT77dshHg+hBtc9YPW-eZ8wVQA9LTDQ6q_y99oiQ@mail.gmail.com>
 <20180801103537.d36t3snzulyuge7g@breakpoint.cc>
 <CACT4Y+aHWpgDZygXv=smWwdVMWfjpedyajuVvvLDGMK-wFD5Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        David Miller <davem@davemloft.net>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@linux.ie>,
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+aHWpgDZygXv=smWwdVMWfjpedyajuVvvLDGMK-wFD5Lw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> wrote:
> On Wed, Aug 1, 2018 at 12:35 PM, Florian Westphal <fw@strlen.de> wrote:
> > Dmitry Vyukov <dvyukov@google.com> wrote:
> >> Still can't grasp all details.
> >> There is state that we read without taking ct->ct_general.use ref
> >> first, namely ct->state and what's used by nf_ct_key_equal.
> >> So let's say the entry we want to find is in the list, but
> >> ____nf_conntrack_find finds a wrong entry earlier because all state it
> >> looks at is random garbage, so it returns the wrong entry to
> >> __nf_conntrack_find_get.
> >
> > If an entry can be found, it can't be random garbage.
> > We never link entries into global table until state has been set up.
> 
> But... we don't hold a reference to the entry. So say it's in the
> table with valid state, now ____nf_conntrack_find discovers it, now
> the entry is removed and reused a dozen of times will all associated
> state reinitialization. And nf_ct_key_equal looks at it concurrently
> and decides if it's the entry we are looking for or now. I think
> unless we hold a ref to the entry, it's state needs to be considered
> random garbage for correctness reasoning.

It checks if it might be the entry we're looking for.

If this was complete random garbage, scheme would not work, as then
we could have entry that isn't in table, has nonzero refcount, but
has its confirmed bit set.

I don't see how that would be possible, any reallocation
makes sure ct->status has CONFIRMED bit clear before setting refcount
to nonzero value.

I think this is the scenario you hint at is:
1. nf_ct_key_equal is true
2. the entry is free'd (or was already free'd)
3. we return NULL to caller due to atomic_inc_not_zero() failure

but i fail to see how thats wrong?

Sure, we could restart lookup but how would that help?

We'd not find the 'candidate' entry again.

We might find entry that has been inserted at this very instant but
newly allocated entries are only inserted into global table until the skb that
created the nf_conn object has made it through the network stack
(postrouting for fowarded, or input for local delivery).

So, the likelyhood of such restart finding another candidate is close to 0,
and won't prevent 'insert race' from happening.
