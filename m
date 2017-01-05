From: Anton Blanchard <anton@samba.org>
Subject: Re: ext4 filesystem corruption with 4.10-rc2 on ppc64le
Date: Thu, 5 Jan 2017 21:44:10 +1100
Message-ID: <20170105214410.0fc5cd58@kryten>
References: <20170104161808.5ad7b4fd@kryten>
 <6085340.JSrffQ0Szo@localhost.localdomain>
 <20170104152837.wdh7cdncs7gyged7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
 jack@suse.cz, linux-kernel@vger.kernel.org, axboe@fb.com,
 torvalds@linux-foundation.org, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
 Paul Mackerras <paulus@samba.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20170104152837.wdh7cdncs7gyged7@thunk.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

> Anton or Chandan, could you do me a favor and verify whether or not
> 64k block sizes are working for you on ppcle on ext4 by running
> xfstests?  Light duty testing works for me but when I stress ext4 with
> pagesize==blocksize on ppcle64 via xfstests, it blows up.  I suspect
> (but am not sure) it's due to (non-upstream) device driver issues, and
> a verification that you can run xfstests on your ppcle64 systems using
> standard upstream device drivers would be very helpful, since I don't
> have easy console access on the machines I have access to at
> $WORK.  :-(

I fired off an xfstests run, and it looks good. There are 3 failures,
but they seem to be setup issues on my part. I also double checked
those same three failed on 4.8.

Chandan has been running the test suite regularly, and plans to do a
run against mainline too.

Anton
