From: Anton Blanchard <anton@ozlabs.org>
Subject: Re: [PATCH 1/2] ext4: fix warning about stack corruption
Date: Tue, 22 Aug 2017 22:23:13 +1000
Message-ID: <20170822222313.468ee7aa@kryten>
References: <20170726185219.GA57833@beast>
        <20170801120438.1582336-1-arnd@arndb.de>
        <20170822210849.0edb91cc@kryten>
        <CAK8P3a05GOh87tGhnuUS_gYmQVjgTrC-e58KagVPG4hHSuFTgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a05GOh87tGhnuUS_gYmQVjgTrC-e58KagVPG4hHSuFTgg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


> > Unfortunately it doesn't appear to work, at least with ppc64le
> > clang:
> >
> > fs/ext4/mballoc.c:2303:17: error: fields must have a constant size:
> > 'variable length array in structure' extension will never be
> > supported ext4_grpblk_t counters[blocksize_bits + 2];  
> 
> My fix for this is in the ext4/dev branch in linux-next, I hope it
> still makes it into v4.13.

Thanks Arnd, I see it now.

Anton
