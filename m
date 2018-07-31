From: Eric Dumazet <edumazet@google.com>
Subject: Re: SLAB_TYPESAFE_BY_RCU without constructors (was Re: [PATCH v4
 13/17] khwasan: add hooks implementation)
Date: Tue, 31 Jul 2018 11:16:28 -0700
Message-ID: <CANn89iLjk-mV3kZGASvZQtYaBDy9sbo=NW4Tt_V=dOP_-b=VNQ@mail.gmail.com>
References: <e3b48104-3efb-1896-0d46-792419f49a75@virtuozzo.com>
 <01000164f169bc6b-c73a8353-d7d9-47ec-a782-90aadcb86bfb-000000@email.amazonses.com>
 <CANn89iLLQP2vA+2J-zxL3Fa75zNw=yRmv3Jg6vcEc=fYeEZ2ow@mail.gmail.com> <CACT4Y+Y6dhNgisDM9hdP-M-Rnk66DxZWcX7v39ESGJR8RY3asQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Christoph Lameter <cl@linux.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "Theodore Ts'o" <tytso@mit.edu>, jack@suse.com,
        linux-ext4@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+Y6dhNgisDM9hdP-M-Rnk66DxZWcX7v39ESGJR8RY3asQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 31, 2018 at 10:51 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
>
> Is it OK to overwrite ct->status? It seems that are some read and
> writes to it right after atomic_inc_not_zero.

If it is after a (successful) atomic_inc_not_zero(),
the object is guaranteed to be alive (not freed or about to be freed).

About readind/writing a specific field, all traditional locking rules apply.

For TCP socket, we would generally grab the socket lock before
reading/writing various fields.

ct->status seems to be manipulated with set_bit() and clear_bit()
which are SMP safe.
