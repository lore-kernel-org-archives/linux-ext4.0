From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Sat, 7 Oct 2017 14:32:13 -0400
Message-ID: <20171007183213.jfezqvcbjslzwm7e@thunk.org>
References: <1503830683-21455-1-git-send-email-amir73il@gmail.com>
 <59C8D147.1060608@cn.fujitsu.com>
 <CAOQ4uxgnK3mGKG+owRUNGyDVOCeicArwaufGgwXaSVxC26+peQ@mail.gmail.com>
 <CAFk8rvYvrGo6SjA6e0yj0XL_BARMmZoofB5kESM4EY4S2n-==w@mail.gmail.com>
 <59D5DEE0.6080506@cn.fujitsu.com>
 <CAFk8rvbi3MHbRBtaZVTJKDcORaDTtMpwy2X2ZdXTZt=LE5smZw@mail.gmail.com>
 <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
 <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
 <20171007032917.bntgnubthdstmrrt@thunk.org>
 <CAOQ4uxio+SuAKk35tBh7_rne+YgCsvfS0yoKdipcUsf9noU+eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ashlie Martinez <ashmrtn@utexas.edu>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Vijay Chidambaram <vvijay03@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxio+SuAKk35tBh7_rne+YgCsvfS0yoKdipcUsf9noU+eg@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 07, 2017 at 08:54:06AM +0300, Amir Goldstein wrote:
> >     If fallocate(2) is called with the FALLOC_FL_KEEP_SIZE flag, either
> 
> According to patch without keep size flag?

Oops, thanks for catching that.  I'll fix the commit description.

> BTW looking at the patch, does truncate racing with fallocate that
> would increase size beyond truncated size works correctly?

Yes, because we the inode is locked via i_mutex (well, now an write
lock on i_rwsem) during both truncate and fallocate operations.

     		 	     	      	  - Ted
