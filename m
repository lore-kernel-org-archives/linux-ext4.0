From: Fengguang Wu <lkp@intel.com>
Subject: Re: [PATCH] fix an endianness bug in ext4_encrypted_follow_link()
Date: Fri, 27 Nov 2015 09:31:54 +0800
Message-ID: <20151127013154.GA23817@wfg-t540p.sh.intel.com>
References: <20151126152728.GT22011@ZenIV.linux.org.uk>
 <1448566837.18647.16.camel@perches.com>
 <20151126210223.GV22011@ZenIV.linux.org.uk>
 <alpine.DEB.2.02.1511262227080.2034@localhost6.localdomain6>
 <1448578076.18647.37.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Julia Lawall <julia.lawall@lip6.fr>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448578076.18647.37.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 26, 2015 at 02:47:56PM -0800, Joe Perches wrote:
> On Thu, 2015-11-26 at 22:28 +0100, Julia Lawall wrote:
> > On Thu, 26 Nov 2015, Al Viro wrote:
> > > On Thu, Nov 26, 2015 at 11:40:37AM -0800, Joe Perches wrote:
> > > (cc'ing Julia Lawall)
> > > > On Thu, 2015-11-26 at 15:27 +0000, Al Viro wrote:
> > > > applying le32_to_cpu() to 16bit value is a bad idea...
> > > Julia, perhaps you or your crew could produce a coccinelle test
> > > for this class of error?
> > What's wrong with something like make C=2 CF=-D__CHECK_ENDIAN__ fs/ext4/ ?
> > Worked just fine, TYVM -
> > sparse does locate them...
> 
> Nothing at all.
> 
> > As long as the code of interest is getting compiled in the current
> > configuration, relying on the compiler for this seems like a better choice.
> 
> Sparse isn't the compiler, but that would be fine by me
> as long as something can catch them.
> 
> The original commit (f348c252320b9) was from April.
> Isn't the kbuild robot using sparse and __CHECK_ENDIAN__?

Yes 0day did catch the sparse warning, however it seems the email
somehow failed to get delivered. Here is the local record:

        Date: Mon, 13 Apr 2015 16:41:54 +0800
        From: kbuild test robot <fengguang.wu@intel.com>
        To: Theodore Ts'o <tytso@mit.edu>
        Cc: kbuild-all@01.org, Uday Savagaonkar <savagaon@google.com>
        Subject: [ext4:dev 32/33] fs/ext4/namei.c:3262:25: sparse: incorrect type in
         assignment (different base types)
        Message-ID: <201504131652.Ox8dW5C0%fengguang.wu@intel.com>
        MIME-Version: 1.0
        Content-Type: text/plain; charset=us-ascii
        Content-Disposition: inline
        User-Agent: Mutt/1.5.23 (2014-03-12)

        tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
        head:   3a19824f63e0a0df99c0a133097eb87c0152545e
        commit: f1195c72c95115858123813e9a84badad37424c0 [32/33] ext4 crypto: Add symlink encryption
        reproduce:
          # apt-get install sparse
          git checkout f1195c72c95115858123813e9a84badad37424c0
          make ARCH=x86_64 allmodconfig
          make C=1 CF=-D__CHECK_ENDIAN__

        sparse warnings: (new ones prefixed by >>)

        >> fs/ext4/namei.c:3262:25: sparse: incorrect type in assignment (different base types)
           fs/ext4/namei.c:3262:25:    expected restricted __le16 [usertype] len
           fs/ext4/namei.c:3262:25:    got restricted __le32 [usertype] <noident>
        --
        >> fs/ext4/symlink.c:74:29: sparse: cast to restricted __le32
        >> fs/ext4/symlink.c:74:29: sparse: cast from restricted __le16

Thanks,
Fengguang
