From: Christopher Lameter <cl@linux.com>
Subject: Re: SLAB_TYPESAFE_BY_RCU without constructors (was Re: [PATCH v4
 13/17] khwasan: add hooks implementation)
Date: Wed, 1 Aug 2018 15:15:51 +0000
Message-ID: <01000164f60f3f12-b1253c6e-ee57-49fc-aed8-0944ab4fd7a2-000000@email.amazonses.com>
References: <e3b48104-3efb-1896-0d46-792419f49a75@virtuozzo.com> <01000164f169bc6b-c73a8353-d7d9-47ec-a782-90aadcb86bfb-000000@email.amazonses.com> <CA+55aFzHR1+YbDee6Cduo6YXHO9LKmLN1wP=MVzbP41nxUb5=g@mail.gmail.com> <CA+55aFzYLgyNp1jsqsvUOjwZdO_1Piqj=iB=rzDShjScdNtkbg@mail.gmail.com>
 <30ee6c72-dc90-275a-8e23-54221f393cb0@virtuozzo.com> <c03fd1ca-0169-4492-7d6f-2df7a91bff5e@gmail.com> <CACT4Y+bLbDunoz+0qB=atbQXJ9Gu3N6+UXPwNnqMbq5RyZu1mQ@mail.gmail.com> <cf751136-c459-853a-0210-abf16f54ad17@gmail.com>
 <CACT4Y+b6aCHMTQD21fSf2AMZoH5g8p-FuCVHviMLF00uFV+zGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
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
In-Reply-To: <CACT4Y+b6aCHMTQD21fSf2AMZoH5g8p-FuCVHviMLF00uFV+zGg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 1 Aug 2018, Dmitry Vyukov wrote:

> But we are trading 1 indirect call for comparable overhead removed
> from much more common path. The path that does ctors is also calling
> into page alloc, which is much more expensive.
> So ctor should be a net win on performance front, no?

ctor would make it esier to review the flow and guarantee that the object
always has certain fields set as required before any use by the subsystem.

ctors are run once on allocation of the slab page for all objects in it.

ctors are not called duiring allocation and freeing of objects from the
slab page. So we could avoid the intialization of the spinlock on each
object allocation which actually should be faster.
