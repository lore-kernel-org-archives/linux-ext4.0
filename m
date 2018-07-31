From: Eric Dumazet <edumazet@google.com>
Subject: Re: SLAB_TYPESAFE_BY_RCU without constructors (was Re: [PATCH v4
 13/17] khwasan: add hooks implementation)
Date: Tue, 31 Jul 2018 10:32:39 -0700
Message-ID: <CANn89iLKwJ5oDfXu8M9z9_Xh0FKHFo961c_ocdUmHQc3Onmykw@mail.gmail.com>
References: <e3b48104-3efb-1896-0d46-792419f49a75@virtuozzo.com> <20180731170957.o4vhopmzgedpo5sh@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "Theodore Ts'o" <tytso@mit.edu>, jack@suse.com,
        linux-ext4@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        David Miller <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ursula Braun <ubraun@linux.ibm.com>,
        linux-s390@vger.kernel.org, LKML <
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180731170957.o4vhopmzgedpo5sh@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 31, 2018 at 10:10 AM Florian Westphal <fw@strlen.de> wrote:
>
> Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> > Guys, it seems that we have a lot of code using SLAB_TYPESAFE_BY_RCU cache without constructor.
> > I think it's nearly impossible to use that combination without having bugs.
> > It's either you don't really need the SLAB_TYPESAFE_BY_RCU, or you need to have a constructor in kmem_cache.
> >
> > Could you guys, please, verify your code if it's really need SLAB_TYPSAFE or constructor?
> >
> > E.g. the netlink code look extremely suspicious:
> >
> >       /*
> >        * Do not use kmem_cache_zalloc(), as this cache uses
> >        * SLAB_TYPESAFE_BY_RCU.
> >        */
> >       ct = kmem_cache_alloc(nf_conntrack_cachep, gfp);
> >       if (ct == NULL)
> >               goto out;
> >
> >       spin_lock_init(&ct->lock);
> >
> > If nf_conntrack_cachep objects really used in rcu typesafe manner, than 'ct' returned by kmem_cache_alloc might still be
> > in use by another cpu. So we just reinitialize spin_lock used by someone else?
>
> That would be a bug, nf_conn objects are reference counted.
>
> spinlock can only be used after object had its refcount incremented.
>
> lookup operation on nf_conn object:
> 1. compare keys
> 2. attempt to obtain refcount (using _not_zero version)
> 3. compare keys again after refcount was obtained
>
> if any of that fails, nf_conn candidate is skipped.


Yes, the key here is the refcount, this is only what we need to clear
after kmem_cache_alloc()

By definition, if an object is being freed/reallocated, the refcount
should be already 0, and clearing it again is a NOP.
