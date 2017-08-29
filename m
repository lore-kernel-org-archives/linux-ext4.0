From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] fs, xfs: perform dax_device lookup at mount
Date: Tue, 29 Aug 2017 14:35:27 -0700
Message-ID: <CAPcyv4i2rS0sAxiJSVxFSHirsycaYofuxp3yPxeyB8xzsryx3g@mail.gmail.com>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170829212606.GC8608@lst.de>
 <CAPcyv4hA_vkSdZowaJ78FPCOhY2Z_iORX0B63=_RCCGdqack_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hA_vkSdZowaJ78FPCOhY2Z_iORX0B63=_RCCGdqack_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Tue, Aug 29, 2017 at 2:31 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Aug 29, 2017 at 2:26 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>> Call me nitpicky, but..
>>
>> First this really should be three patches, one for the DAX code, one
>> for the VFS code and one for XFS.  The DAX and XFS bits looks fine to
>> me:
>>
>> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>>
>> But I'm a little worried about stuffing more DAX knowledge into the
>> block mount_bdev helper.  For now it's probably ok as everything
>> else would involve a lot of refactoring and/or duplication, but
>> I'm generally not too happy about it.
>
> I think this is why we ended up with calling dax_get_by_host() in
> ->iomap_begin() because the mount_bdev() touches I started with back
> when this was first introduced were not very palatable. I agree with
> the direction to move to mount_dax() in the future. I can respin this
> into three patches and a TODO comment about how we want to kill the
> dax knowledge in mount_bdev() going forward.

Actually, why not just do this directly in xfs_fs_mount()? I think I
can refactor this to not touch mount_bdev() and put all the details in
the per-fs mount/umount paths.
