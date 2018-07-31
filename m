From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Help trying to use /dev/pmem for dax debugging?
Date: Tue, 31 Jul 2018 13:27:15 -0700
Message-ID: <30247efc-88f8-3e0b-fcd8-83801be5f041@intel.com>
References: <20180730235312.GA5089@thunk.org>
 <20180731193642.GA3473@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180731193642.GA3473-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
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


On 7/31/2018 12:36 PM, Ross Zwisler wrote:
> On Mon, Jul 30, 2018 at 07:53:12PM -0400, Theodore Y. Ts'o wrote:
>> In newer kernels, it looks like you can't use /dev/pmem0 for DAX
>> unless it's marked as being DAX capable.  This appears to require
>> CONFIG_NVDIMM_PFN.  But when I tried to build a kernel with that
>> configured, I get the following BUG:
>>
>> [    0.000000] Linux version 4.18.0-rc4-xfstests-00031-g7c2d77aa7d80 (tytso@cwcc) (gcc version 7.3.0 (Debian 7.3.0-27)) #460 SMP Mon Jul 30 19:38:44 EDT 2018
>> [    0.000000] Command line: systemd.show_status=auto systemd.log_level=crit root=/dev/vda console=ttyS0,115200 cmd=maint fstesttz=America/New_York fstesttyp=ext4 fstestapi=1.4 memmap=4G!9G memmap=9G!14G
> Hey Ted,
>
> You're using the memmap kernel command line parameter to reserve normal
> memory to be treated as normal memory, but you've also got kernel address
> randomization turned on in your kernel config:
>
> CONFIG_RANDOMIZE_BASE=y
> CONFIG_RANDOMIZE_MEMORY=y
>
> You need to turn these off for the memmap kernel command line parameter, else
> the memory we're using could overlap with addresses used for other things.

I believe this issue was fixed a while back. Although we probably can 
see if that is the issue or something else.


>
> Once that is off you probably want to double check that the addresses you're
> reserving are marked as 'usable' in the e820 table.  Gory details here, sorry
> for the huge link:
>
> https://nvdimm.wiki.kernel.org/how_to_choose_the_correct_memmap_kernel_parameter_for_pmem_on_your_system
>
> - Ross
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
