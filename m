From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 0/6 v2] dax: Page invalidation fixes
Date: Thu, 24 Nov 2016 10:46:30 +0100
Message-ID: <1479980796-26161-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
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

Hello,

this is second revision of my fixes of races when invalidating hole pages in
DAX mappings. See changelogs for details. The series is based on my patches to
write-protect DAX PTEs which are currently carried in mm tree. This is a hard
dependency because we really need to closely track dirtiness (and cleanness!)
of radix tree entries in DAX mappings in order to avoid discarding valid dirty
bits leading to missed cache flushes on fsync(2).

The tests have passed xfstests for xfs and ext4 in DAX and non-DAX mode.

I'd like to get some review of the patches (MM/FS people, please check whether
you like the direction changes in mm/truncate.c take in patch 2/6 - added
Johannes to CC since he was touching related code recently) so that these
patches can land in some tree once DAX write-protection patches are merged.
I'm hoping to get at least first three patches merged for 4.10-rc2... Thanks!

Changes since v1:
* Rebased on top of patches in mm tree
* Added some Reviewed-by tags
* renamed some functions based on review feedback

								Honza
