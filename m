From: Ye Xiaolong <xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [kbuild-all] [PATCH] mm: replace FAULT_FLAG_SIZE with parameter
 to huge_fault
Date: Thu, 9 Feb 2017 12:34:43 +0800
Message-ID: <20170209043443.GB13723@yexl-desktop>
References: <201702040648.oOjnlEcm%fengguang.wu@intel.com>
 <2020f442-8e77-cf14-a6b1-b4b00d0da80b@intel.com>
 <CAPcyv4hmswhXsnS9q1Ut76f3-a2h5Hx7XYkS1iNyak8wG9VuEw@mail.gmail.com>
 <CAPcyv4hVqxedr9sEigw0Xsr_SoMAnvPrmPNOrX7QYNuCz=DRQA@mail.gmail.com>
 <86962573-01b7-4ce7-182e-7a77f183cf0e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org,
 Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <86962573-01b7-4ce7-182e-7a77f183cf0e-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 02/03, Dave Jiang wrote:
>On 02/03/2017 05:00 PM, Dan Williams wrote:
>> On Fri, Feb 3, 2017 at 3:26 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> On Fri, Feb 3, 2017 at 3:25 PM, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>> On 02/03/2017 03:56 PM, kbuild test robot wrote:
>>>>> Hi Dave,
>>>>>
>>>>> [auto build test ERROR on mmotm/master]
>>>>> [cannot apply to linus/master linux/master v4.10-rc6 next-20170203]
>>>>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>>>
>>>> This one is a bit odd. I just pulled mmotm tree master branch and built
>>>> with the attached .config and it passed for me (and I don't see this
>>>> commit in the master branch). I also built linux-next with this patch on
>>>> top and it also passes with attached .config. Looking at the err log
>>>> below it seems the code has a mix of partial from before and after the
>>>> patch. I'm rather confused about it....
>>>
>>> This is a false positive. It tried to build it against latest mainline
>>> instead of linux-next.
>> 
>> On second look it seems I ended up with a duplicate
>> ext4_huge_dax_fault after "git am" when I apply this on top of
>> next-20170202.  The following fixes it up for me and tests fine:
>
>I think it's missing this patch from Ross
>http://marc.info/?l=linux-mm&m=148581319303697&w=2

Yes, 0day applied the patch on top of mmotm/master when this fix commit 0c4044b3f
("ext4: Remove unused function ext4_dax_huge_fault()") hasn't been merged.

Thanks,
Xiaolong
>
>> 
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index f8f4f6d068e5..e8ab46efc4f9 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -276,27 +276,6 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>>         return result;
>>  }
>> 
>> -static int
>> -ext4_dax_huge_fault(struct vm_fault *vmf)
>> -{
>> -       int result;
>> -       struct inode *inode = file_inode(vmf->vma->vm_file);
>> -       struct super_block *sb = inode->i_sb;
>> -       bool write = vmf->flags & FAULT_FLAG_WRITE;
>> -
>> -       if (write) {
>> -               sb_start_pagefault(sb);
>> -               file_update_time(vmf->vma->vm_file);
>> -       }
>> -       down_read(&EXT4_I(inode)->i_mmap_sem);
>> -       result = dax_iomap_fault(vmf, &ext4_iomap_ops);
>> -       up_read(&EXT4_I(inode)->i_mmap_sem);
>> -       if (write)
>> -               sb_end_pagefault(sb);
>> -
>> -       return result;
>> -}
>> -
>>  static int ext4_dax_fault(struct vm_fault *vmf)
>>  {
>>         return ext4_dax_huge_fault(vmf, PE_SIZE_PTE);
>> 
>_______________________________________________
>kbuild-all mailing list
>kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
>https://lists.01.org/mailman/listinfo/kbuild-all
