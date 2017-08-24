From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Date: Thu, 24 Aug 2017 15:26:52 -0400
Message-ID: <20170824192652.tsxkgorgyuybta6m@thunk.org>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

On Wed, Aug 23, 2017 at 02:26:52PM -0700, rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> If an ext4 filesystem is mounted with both the DAX and read-only
> options, executables on that filesystem will fail to start (claiming
> 'Segmentation fault') due to the fault handler returning
> VM_FAULT_SIGBUS.
> 
> This is due to the DAX fault handler (see ext4_dax_huge_fault)
> attempting to write to the journal when FAULT_FLAG_WRITE is set. This is
> the wrong behavior for write faults which will lead to a COW page; in
> particular, this fails for readonly mounts.
> 
> This change avoids journal writes for faults that are expected to COW.
> 
> It might be the case that this could be better handled in
> ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
> dax_iomap_fault). These is some overlap already (e.g. grabbing journal
> handles).
> 
> Signed-off-by: Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Applied, thanks!!

					- Ted
