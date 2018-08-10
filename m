From: Dan Williams <dan.j.williams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Help trying to use /dev/pmem for dax debugging?
Date: Fri, 10 Aug 2018 10:28:24 -0700
Message-ID: <CAA9_cmdSxy4vw3wQwj_nkWX+s3Z5-z6rkf9H6j-q-SFZyc5URA@mail.gmail.com>
References: <20180730235312.GA5089@thunk.org>
 <20180731193642.GA3473@linux.intel.com>
 <30247efc-88f8-3e0b-fcd8-83801be5f041@intel.com>
 <20180810025339.GB21087@thunk.org>
 <4222843a-13ea-e88f-ca74-4e3fe53b4105@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, ext4 hackers <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: "dave.jiang" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <4222843a-13ea-e88f-ca74-4e3fe53b4105-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

Fixed here:

https://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git/commit/?h=akpm/mm&id=6a1830efaf3318696479475620414ccb703757a5

Sent from my phone, forgive formatting.

On Fri, Aug 10, 2018, 9:18 AM Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>
>
> On 08/09/2018 07:53 PM, Theodore Y. Ts'o wrote:
> > On Tue, Jul 31, 2018 at 01:27:15PM -0700, Dave Jiang wrote:
> >>
> >> On 7/31/2018 12:36 PM, Ross Zwisler wrote:
> >>> On Mon, Jul 30, 2018 at 07:53:12PM -0400, Theodore Y. Ts'o wrote:
> >>>> In newer kernels, it looks like you can't use /dev/pmem0 for DAX
> >>>> unless it's marked as being DAX capable.  This appears to require
> >>>> CONFIG_NVDIMM_PFN.  But when I tried to build a kernel with that
> >>>> configured, I get the following BUG:
> >>>
> >>> You're using the memmap kernel command line parameter to reserve normal
> >>> memory to be treated as normal memory, but you've also got kernel
> address
> >>> randomization turned on in your kernel config:
> >>>
> >>> CONFIG_RANDOMIZE_BASE=y
> >>> CONFIG_RANDOMIZE_MEMORY=y
> >>>
> >>> You need to turn these off for the memmap kernel command line
> parameter, else
> >>> the memory we're using could overlap with addresses used for other
> things.
> >>
> >> I believe this issue was fixed a while back. Although we probably can
> see if
> >> that is the issue or something else.
> >
> > I turned off RANDOMIZE_BASE and RANDOMIZE_MEMORY, but that didn't fix
> > my problem.
> >
> > It turns out the problem was KASAN.  It looks like using memmap to
> > create test /dev/pmemX devices is not compatible with CONFIG_KASAN
> > being enabled.
> >
> > So I have a workaround for now, but it seems this to be a bug in
> > KASAN, or at least an unfortunate interaction between KASAN and
> > NVDIMM_PFN.
>
> Thanks Ted. I have updated the wiki Ross mentioned to reflect that.
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
>
