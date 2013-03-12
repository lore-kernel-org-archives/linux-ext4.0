From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Mon, 11 Mar 2013 23:44:22 -0400
Message-ID: <20130312034422.GC18595@thunk.org>
References: <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
 <20130312030057.GA6142@gmail.com>
 <20130312033054.GB18595@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130312033054.GB18595@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 11, 2013 at 11:30:54PM -0400, Theodore Ts'o wrote:
> > As Ted suggested, could you please try to use ext4 git tree?  I want to
> > make sure whether this bug has been fixed by my lastest patch series or
> > not.
> 
> It's definitely worth a try to compile the master branch of the ext4
> tree and see if it reproduces or not.

Sorry, what you should try is the dev branch of the ext4 tree.  That
has the new patches that we are currently QA'ing for 3.9-rc3
(hopefully).

					- Ted
