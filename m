From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
Date: Fri, 10 Aug 2018 14:26:42 -0500
Message-ID: <7930740d-7097-90b7-a4c2-f81d520f411f@redhat.com>
References: <153374942137.42241.10539674028265137668.stgit@djiang5-desk3.ch.intel.com>
 <be8603ab-ccb2-3f0d-4dbf-7935fc3ed357@redhat.com>
 <c4580e0d-e403-88a4-0e3a-7be8d0489f09@intel.com>
 <CAOxpaSWwfd4Wat3v_iH1QymGh51QdcK1=7fsOUeXrdfqui4K=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <zwisler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAOxpaSWwfd4Wat3v_iH1QymGh51QdcK1=7fsOUeXrdfqui4K=g@mail.gmail.com>
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

On 8/10/18 2:24 PM, Ross Zwisler wrote:
> On Fri, Aug 10, 2018 at 9:23 AM Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On 08/10/2018 11:31 AM, Eric Sandeen wrote:
>>> On 8/8/18 12:31 PM, Dave Jiang wrote:
>>>> This patch is the duplicate of ross's fix for ext4 for xfs.
>>>>
>>>> If the refcount of a page is lowered between the time that it is returned
>>>> by dax_busy_page() and when the refcount is again checked in
>>>> xfs_break_layouts() => ___wait_var_event(), the waiting function
>>>> xfs_wait_dax_page() will never be called.  This means that
>>>> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
>>>> looping and never check the refcount of other pages in this inode.
>>>>
>>>> Instead, always continue looping as long as dax_layout_busy_page() gives us
>>>> a page which it found with an elevated refcount.
>>>
>>> Hi Dave, does this have a testcase?  Have you seen the issue using Ross's
>>> xfstest generic/503 or is there some other test?  Apologies if I missed
>>> prior discussion on a testcase or race frequency...
>>
>> I do not have a testcase. I know Ross replicated it on ext4. And Jan
>> asked to create the same fix with XFS when he reviewed Ross's fix for ext4.
> 
> In my testing I couldn't get this race to hit with XFS.  I couldn't
> even get a failure with generic/503 when testing XFS before Dan's
> initial patches went in which added xfs_break_layouts() et al.  I
> think that Dan had to manually insert timing delays to get the warning
> to hit for XFS when testing his patches.
> 
> The race we're fixing happens consistently with ext4 and through code
> inspection we can see that the race exists in XFS.

Ok, thanks for the info Dave & Ross!

-Eric
