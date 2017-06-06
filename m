From: Radim Krcmar <rkrcmar@redhat.com>
Subject: Re: [PATCH] kvm: async_pf: fix rcu_irq_enter() with irqs enabled
Date: Tue, 6 Jun 2017 15:28:58 +0200
Message-ID: <20170606132857.GB10167@potion>
References: <20170426145626.6407-1-pbonzini@redhat.com>
 <CANRm+CxZZxQkZwNPKPwTyrh_XdoLYeMqexjdkZdhx7pXOMf=+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, ross.zwisler@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, jack@suse.cz,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        Josh Triplett <josh@joshtriplett.org>,
        "# v3 . 10+" <stable@vger.kernel.org>
To: Wanpeng Li <kernellwp@gmail.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANRm+CxZZxQkZwNPKPwTyrh_XdoLYeMqexjdkZdhx7pXOMf=+Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2017-06-05 12:21+0800, Wanpeng Li:
> 2017-04-26 22:56 GMT+08:00 Paolo Bonzini <pbonzini@redhat.com>:
> > native_safe_halt enables interrupts, and you just shouldn't
> > call rcu_irq_enter() with interrupts enabled.  Reorder the
> > call with the following local_irq_disable() to respect the
> > invariant.
> >
> > Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> I'm afraid we miss this commit. This commit can fix the below warning

Applied to kvm/master,

> Tested-by: Wanpeng Li <wanpeng.li@hotmail.com>

thanks for the testing and ping!
