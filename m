From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: DAX can not work on virtual nvdimm device
Date: Fri, 9 Sep 2016 10:03:27 -0400
Message-ID: <20160909140327.r2j64s5xdaxnnxhx@thunk.org>
References: <20160819183047.GA7216@linux.intel.com>
 <600ac51c-0f61-6e53-9bfa-669c85494d1f@linux.intel.com>
 <20160829193014.GB16738@linux.intel.com>
 <61d5c470-a8bf-86d5-d1fe-b4b577a85967@linux.intel.com>
 <CAPcyv4hrFSxNcmmVLVZT4fK3+hspPCDKW0rVBj1=3GkJRgZ29Q@mail.gmail.com>
 <25098f37-53f7-6d5d-0b1a-8469bab51a9f@linux.intel.com>
 <20160902025738.GA26108@linux.intel.com>
 <20160906150620.GJ28922@quack2.suse.cz>
 <20160908204708.GA15167@linux.intel.com>
 <20160909091925.GF22777@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Yumei Huang <yuhuang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, KVM <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>,
 "qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org" <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>,
 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160909091925.GF22777-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 09, 2016 at 11:19:25AM +0200, Jan Kara wrote:
> > > > > 1. make the guest kernel based on your tree, the top commit is
> > > > >    10d7902fa0e82b (dax: unmap/truncate on device shutdown) and
> > > > >    the config file can be found in this thread.

What git tree is 10d7902fa0e82b from?

> Hum, nothing unusual in there. I've tried reproducing on a local SLE11 SP3
> machine (which is from about the same time) but everything works as
> expected there. Shrug...

I just tried reproducing it via "gce-xfstests --pmem-device shell"
with a downgraded e2fsprogs to stock upstream 1.42.12, and I can't
reproduce it with the ext4.git tree.  I'm not sure whether the git
commit is critical, though.  Is this a regression that was working
before?

Or it's possible that Red Hat did something weird with the CentOS 6
e2fsprogs....

					- Ted
