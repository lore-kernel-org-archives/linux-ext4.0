From: Toshi Kani <toshi.kani@hpe.com>
Subject: Re: dax pmd fault handler never returns to userspace
Date: Wed, 18 Nov 2015 14:33:09 -0700
Message-ID: <1447882389.21443.151.camel@hpe.com>
References: <x49wptfnw2l.fsf@segfault.boston.devel.redhat.com>
	 <CAPcyv4jnNNFAp_L5BFbP4K6vNhffELSS7g0aekhGnCadsBCfnw@mail.gmail.com>
	 <20151118170014.GB10656@linux.intel.com>
	 <x4937w3nqze.fsf@segfault.boston.devel.redhat.com>
	 <CAPcyv4grgkLTVHdGhVSOs1sXsiLQyB1ubcRvmhW=hMZnA9MnHQ@mail.gmail.com>
	 <20151118182320.GA7901@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-d1XwpQ0qbHDz3iQMGjyv"
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>,
	Ross Zwisler <ross.zwisler@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151118182320.GA7901@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-d1XwpQ0qbHDz3iQMGjyv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2015-11-18 at 11:23 -0700, Ross Zwisler wrote:
> On Wed, Nov 18, 2015 at 10:10:45AM -0800, Dan Williams wrote:
> > On Wed, Nov 18, 2015 at 9:43 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > > Ross Zwisler <ross.zwisler@linux.intel.com> writes:
> > > 
> > > > On Wed, Nov 18, 2015 at 08:52:59AM -0800, Dan Williams wrote:
> > > > > Sysrq-t or sysrq-w dump?  Also do you have the locking fix from Yigal?
> > > > > 
> > > > > https://lists.01.org/pipermail/linux-nvdimm/2015-November/002842.html
> > > > 
> > > > I was able to reproduce the issue in my setup with v4.3, and the patch
> > > > from
> > > > Yigal seems to solve it.  Jeff, can you confirm?
> > > 
> > > I applied the patch from Yigal and the symptoms persist.  Ross, what are
> > > you testing on?  I'm using an NVDIMM-N.
> > > 
> > > Dan, here's sysrq-l (which is what w used to look like, I think).  Only
> > > cpu 3 is interesting:
> > > 
> > > [  825.339264] NMI backtrace for cpu 3
> > > [  825.356347] CPU: 3 PID: 13555 Comm: blk_non_zero.st Not tainted 4.4.0
> > > -rc1+ #17
> > > [  825.392056] Hardware name: HP ProLiant DL380 Gen9, BIOS P89 06/09/2015
> > > [  825.424472] task: ffff880465bf6a40 ti: ffff88046133c000 task.ti:
> > > ffff88046133c000
> > > [  825.461480] RIP: 0010:[<ffffffff81329856>]  [<ffffffff81329856>]
> > > strcmp+0x6/0x30
> > > [  825.497916] RSP: 0000:ffff88046133fbc8  EFLAGS: 00000246
> > > [  825.524836] RAX: 0000000000000000 RBX: ffff880c7fffd7c0 RCX:
> > > 000000076c800000
> > > [  825.566847] RDX: 000000076c800fff RSI: ffffffff818ea1c8 RDI:
> > > ffffffff818ea1c8
> > > [  825.605265] RBP: ffff88046133fbc8 R08: 0000000000000001 R09:
> > > ffff8804652300c0
> > > [  825.643628] R10: 00007f1b4fe0b000 R11: ffff880465230228 R12:
> > > ffffffff818ea1bd
> > > [  825.681381] R13: 0000000000000001 R14: ffff88046133fc20 R15:
> > > 0000000080000200
> > > [  825.718607] FS:  00007f1b5102d880(0000) GS:ffff88046f8c0000(0000)
> > > knlGS:00000000000000
> > > 00
> > > [  825.761663] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  825.792213] CR2: 00007f1b4fe0b000 CR3: 000000046b225000 CR4:
> > > 00000000001406e0
> > > [  825.830906] Stack:
> > > [  825.841235]  ffff88046133fc10 ffffffff81084610 000000076c800000
> > > 000000076c800fff
> > > [  825.879533]  000000076c800fff 00000000ffffffff ffff88046133fc90
> > > ffffffff8106d1d0
> > > [  825.916774]  000000000000000c ffff88046133fc80 ffffffff81084f0d
> > > 000000076c800000
> > > [  825.953220] Call Trace:
> > > [  825.965386]  [<ffffffff81084610>] find_next_iomem_res+0xd0/0x130
> > > [  825.996804]  [<ffffffff8106d1d0>] ? pat_enabled+0x20/0x20
> > > [  826.024773]  [<ffffffff81084f0d>] walk_system_ram_range+0x8d/0xf0
> > > [  826.055565]  [<ffffffff8106d2d8>] pat_pagerange_is_ram+0x78/0xa0
> > > [  826.088971]  [<ffffffff8106d475>] lookup_memtype+0x35/0xc0
> > > [  826.121385]  [<ffffffff8106e33b>] track_pfn_insert+0x2b/0x60
> > > [  826.154600]  [<ffffffff811e5523>] vmf_insert_pfn_pmd+0xb3/0x210
> > > [  826.187992]  [<ffffffff8124acab>] __dax_pmd_fault+0x3cb/0x610
> > > [  826.221337]  [<ffffffffa0769910>] ? ext4_dax_mkwrite+0x20/0x20 [ext4]
> > > [  826.259190]  [<ffffffffa0769a4d>] ext4_dax_pmd_fault+0xcd/0x100 [ext4]
> > > [  826.293414]  [<ffffffff811b0af7>] handle_mm_fault+0x3b7/0x510
> > > [  826.323763]  [<ffffffff81068f98>] __do_page_fault+0x188/0x3f0
> > > [  826.358186]  [<ffffffff81069230>] do_page_fault+0x30/0x80
> > > [  826.391212]  [<ffffffff8169c148>] page_fault+0x28/0x30
> > > [  826.420752] Code: 89 e5 74 09 48 83 c2 01 80 3a 00 75 f7 48 83 c6 01 0f
> > > b6 4e ff 48 83
> > >  c2 01 84 c9 88 4a ff 75 ed 5d c3 0f 1f 00 55 48 89 e5 eb 04 <84> c0 74 18
> > > 48 83 c7 01 0f
> > >  b6 47 ff 48 83 c6 01 3a 46 ff 74 eb
> > 
> > Hmm, a loop in the resource sibling list?
> > 
> > What does /proc/iomem say?
> > 
> > Not related to this bug, but lookup_memtype() looks broken for pmd
> > mappings as we only check for PAGE_SIZE instead of HPAGE_SIZE.  Which
> > will cause problems if we're straddling the end of memory.
> > 
> > > The full output is large (48 cpus), so I'm going to be lazy and not
> > > cut-n-paste it here.
> > 
> > Thanks for that ;-)
> 
> Yea, my first round of testing was broken, sorry about that.
> 
> It looks like this test causes the PMD fault handler to be called repeatedly
> over and over until you kill the userspace process.  This doesn't happen for
> XFS because when using XFS this test doesn't hit PMD faults, only PTE faults.
> 
> So, looks like a livelock as far as I can tell.
> 
> Still debugging.

I am seeing a similar/same problem in my test.  I think the problem is that in
case of a WP fault, wp_huge_pmd() -> __dax_pmd_fault() -> vmf_insert_pfn_pmd(),
which is a no-op since the PMD is mapped already.  We need WP handling for this
PMD map.

If it helps, I have attached change for follow_trans_huge_pmd().  I have not
tested much, though.

Thanks,
-Toshi
--=-d1XwpQ0qbHDz3iQMGjyv
Content-Disposition: attachment; filename="follow_pfn_pmd.patch"
Content-Type: text/x-patch; name="follow_pfn_pmd.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

Ci0tLQogaW5jbHVkZS9saW51eC9tbS5oIHwgICAgMiArKwogbW0vZ3VwLmMgICAgICAgICAgIHwg
ICAyNCArKysrKysrKysrKysrKysrKysrKysrKysKIG1tL2h1Z2VfbWVtb3J5LmMgICB8ICAgIDgg
KysrKysrKysKIDMgZmlsZXMgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvbW0uaCBiL2luY2x1ZGUvbGludXgvbW0uaAppbmRleCAwMGJhZDc3Li5h
NDI3Yjg4IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L21tLmgKKysrIGIvaW5jbHVkZS9saW51
eC9tbS5oCkBAIC0xMDg0LDYgKzEwODQsOCBAQCBzdHJ1Y3QgemFwX2RldGFpbHMgewogCiBzdHJ1
Y3QgcGFnZSAqdm1fbm9ybWFsX3BhZ2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHVuc2ln
bmVkIGxvbmcgYWRkciwKIAkJcHRlX3QgcHRlKTsKK2ludCBmb2xsb3dfcGZuX3BtZChzdHJ1Y3Qg
dm1fYXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyZXNzLAorCQlwbWRfdCAqcG1k
LCB1bnNpZ25lZCBpbnQgZmxhZ3MpOwogCiBpbnQgemFwX3ZtYV9wdGVzKHN0cnVjdCB2bV9hcmVh
X3N0cnVjdCAqdm1hLCB1bnNpZ25lZCBsb25nIGFkZHJlc3MsCiAJCXVuc2lnbmVkIGxvbmcgc2l6
ZSk7CmRpZmYgLS1naXQgYS9tbS9ndXAuYyBiL21tL2d1cC5jCmluZGV4IGRlYWZhMmMuLjE1MTM1
ZWUgMTAwNjQ0Ci0tLSBhL21tL2d1cC5jCisrKyBiL21tL2d1cC5jCkBAIC0zNCw2ICszNCwzMCBA
QCBzdGF0aWMgc3RydWN0IHBhZ2UgKm5vX3BhZ2VfdGFibGUoc3RydWN0IHZtX2FyZWFfc3RydWN0
ICp2bWEsCiAJcmV0dXJuIE5VTEw7CiB9CiAKK2ludCBmb2xsb3dfcGZuX3BtZChzdHJ1Y3Qgdm1f
YXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyZXNzLAorCQlwbWRfdCAqcG1kLCB1
bnNpZ25lZCBpbnQgZmxhZ3MpCit7CisJLyogTm8gcGFnZSB0byBnZXQgcmVmZXJlbmNlICovCisJ
aWYgKGZsYWdzICYgRk9MTF9HRVQpCisJCXJldHVybiAtRUZBVUxUOworCisJaWYgKGZsYWdzICYg
Rk9MTF9UT1VDSCkgeworCQlwbWRfdCBlbnRyeSA9ICpwbWQ7CisKKwkJaWYgKGZsYWdzICYgRk9M
TF9XUklURSkKKwkJCWVudHJ5ID0gcG1kX21rZGlydHkoZW50cnkpOworCQllbnRyeSA9IHBtZF9t
a3lvdW5nKGVudHJ5KTsKKworCQlpZiAoIXBtZF9zYW1lKCpwbWQsIGVudHJ5KSkgeworCQkJc2V0
X3BtZF9hdCh2bWEtPnZtX21tLCBhZGRyZXNzLCBwbWQsIGVudHJ5KTsKKwkJCXVwZGF0ZV9tbXVf
Y2FjaGVfcG1kKHZtYSwgYWRkcmVzcywgcG1kKTsKKwkJfQorCX0KKworCS8qIFByb3BlciBwYWdl
IHRhYmxlIGVudHJ5IGV4aXN0cywgYnV0IG5vIGNvcnJlc3BvbmRpbmcgc3RydWN0IHBhZ2UgKi8K
KwlyZXR1cm4gLUVFWElTVDsKK30KKwogc3RhdGljIGludCBmb2xsb3dfcGZuX3B0ZShzdHJ1Y3Qg
dm1fYXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyZXNzLAogCQlwdGVfdCAqcHRl
LCB1bnNpZ25lZCBpbnQgZmxhZ3MpCiB7CmRpZmYgLS1naXQgYS9tbS9odWdlX21lbW9yeS5jIGIv
bW0vaHVnZV9tZW1vcnkuYwppbmRleCBjMjlkZGViLi40MWIyNzdhIDEwMDY0NAotLS0gYS9tbS9o
dWdlX21lbW9yeS5jCisrKyBiL21tL2h1Z2VfbWVtb3J5LmMKQEAgLTEyNzYsNiArMTI3Niw3IEBA
IHN0cnVjdCBwYWdlICpmb2xsb3dfdHJhbnNfaHVnZV9wbWQoc3RydWN0IHZtX2FyZWFfc3RydWN0
ICp2bWEsCiB7CiAJc3RydWN0IG1tX3N0cnVjdCAqbW0gPSB2bWEtPnZtX21tOwogCXN0cnVjdCBw
YWdlICpwYWdlID0gTlVMTDsKKwlpbnQgcmV0OwogCiAJYXNzZXJ0X3NwaW5fbG9ja2VkKHBtZF9s
b2NrcHRyKG1tLCBwbWQpKTsKIApAQCAtMTI5MCw2ICsxMjkxLDEzIEBAIHN0cnVjdCBwYWdlICpm
b2xsb3dfdHJhbnNfaHVnZV9wbWQoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsCiAJaWYgKChm
bGFncyAmIEZPTExfTlVNQSkgJiYgcG1kX3Byb3Rub25lKCpwbWQpKQogCQlnb3RvIG91dDsKIAor
CS8qIHBmbiBtYXAgZG9lcyBub3QgaGF2ZSBzdHJ1Y3QgcGFnZSAqLworCWlmICh2bWEtPnZtX2Zs
YWdzICYgKFZNX1BGTk1BUCB8IFZNX01JWEVETUFQKSkgeworCQlyZXQgPSBmb2xsb3dfcGZuX3Bt
ZCh2bWEsIGFkZHIsIHBtZCwgZmxhZ3MpOworCQlwYWdlID0gRVJSX1BUUihyZXQpOworCQlnb3Rv
IG91dDsKKwl9CisKIAlwYWdlID0gcG1kX3BhZ2UoKnBtZCk7CiAJVk1fQlVHX09OX1BBR0UoIVBh
Z2VIZWFkKHBhZ2UpLCBwYWdlKTsKIAlpZiAoZmxhZ3MgJiBGT0xMX1RPVUNIKSB7Cg==


--=-d1XwpQ0qbHDz3iQMGjyv--

