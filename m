From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Help trying to use /dev/pmem for dax debugging?
Date: Fri, 10 Aug 2018 09:18:11 -0700
Message-ID: <4222843a-13ea-e88f-ca74-4e3fe53b4105@intel.com>
References: <20180730235312.GA5089@thunk.org>
 <20180731193642.GA3473@linux.intel.com>
 <30247efc-88f8-3e0b-fcd8-83801be5f041@intel.com>
 <20180810025339.GB21087@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180810025339.GB21087-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
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



On 08/09/2018 07:53 PM, Theodore Y. Ts'o wrote:
> On Tue, Jul 31, 2018 at 01:27:15PM -0700, Dave Jiang wrote:
>>
>> On 7/31/2018 12:36 PM, Ross Zwisler wrote:
>>> On Mon, Jul 30, 2018 at 07:53:12PM -0400, Theodore Y. Ts'o wrote:
>>>> In newer kernels, it looks like you can't use /dev/pmem0 for DAX
>>>> unless it's marked as being DAX capable.  This appears to require
>>>> CONFIG_NVDIMM_PFN.  But when I tried to build a kernel with that
>>>> configured, I get the following BUG:
>>>
>>> You're using the memmap kernel command line parameter to reserve normal
>>> memory to be treated as normal memory, but you've also got kernel address
>>> randomization turned on in your kernel config:
>>>
>>> CONFIG_RANDOMIZE_BASE=y
>>> CONFIG_RANDOMIZE_MEMORY=y
>>>
>>> You need to turn these off for the memmap kernel command line parameter, else
>>> the memory we're using could overlap with addresses used for other things.
>>
>> I believe this issue was fixed a while back. Although we probably can see if
>> that is the issue or something else.
> 
> I turned off RANDOMIZE_BASE and RANDOMIZE_MEMORY, but that didn't fix
> my problem.
> 
> It turns out the problem was KASAN.  It looks like using memmap to
> create test /dev/pmemX devices is not compatible with CONFIG_KASAN
> being enabled.
> 
> So I have a workaround for now, but it seems this to be a bug in
> KASAN, or at least an unfortunate interaction between KASAN and
> NVDIMM_PFN.

Thanks Ted. I have updated the wiki Ross mentioned to reflect that.
