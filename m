From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Fri, 14 Jan 2011 09:00:22 +0800
Message-ID: <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
	<AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
	<20110113074603.GC27381@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001485f46e5a6fc4960499c3f534
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58295 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1ANBAY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 20:00:24 -0500
In-Reply-To: <20110113074603.GC27381@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001485f46e5a6fc4960499c3f534
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> On Thu, Jan 13, 2011 at 01:38:55PM +0800, Shaohua Li wrote:
>> 2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
>> > On certain types of storage hardware, flushing the write cache takes a
>> > considerable amount of time. =A0Typically, these are simple storage sy=
stems with
>> > write cache enabled and no battery to save that cache during a power f=
ailure.
>> > When we encounter a system with many I/O threads that try to flush the=
 cache,
>> > performance is suboptimal because each of those threads issues its own=
 flush
>> > command to the drive instead of trying to coordinate the flushes, ther=
eby
>> > wasting execution time.
>> >
>> > Instead of each thread initiating its own flush, we now try to detect =
the
>> > situation where multiple threads are issuing flush requests. =A0The fi=
rst thread
>> > to enter blkdev_issue_flush becomes the owner of the flush, and all th=
reads
>> > that enter blkdev_issue_flush before the flush finishes are queued up =
to wait
>> > for the next flush. =A0When that first flush finishes, one of those sl=
eeping
>> > threads is woken up to perform the next flush and then wake up the oth=
er
>> > threads which are asleep waiting for the second flush to finish.
>> >
>> > In the single-threaded case, the thread will simply issue the flush an=
d exit.
>> >
>> > To test the performance of this latest patch, I created a spreadsheet
>> > reflecting the performance numbers I obtained with the same ffsb fsync=
-happy
>> > workload that I've been running all along: =A0http://tinyurl.com/6xqk5=
bs
>> >
>> > The second tab of the workbook provides easy comparisons of the perfor=
mance
>> > before and after adding flush coordination to the block layer. =A0Vari=
ations in
>> > the runs were never more than about 5%, so the slight performance incr=
eases and
>> > decreases are negligible. =A0It is expected that devices with low flus=
h times
>> > should not show much change, whether the low flush times are due to th=
e lack of
>> > write cache or the controller having a battery and thereby ignoring th=
e flush
>> > command.
>> >
>> > Notice that the elm3b231_ipr, elm3b231_bigfc, elm3b57, elm3c44_ssd,
>> > elm3c44_sata_wc, and elm3c71_scsi profiles showed large performance in=
creases
>> > from flush coordination. =A0These 6 configurations all feature large w=
rite caches
>> > without battery backups, and fairly high (or at least non-zero) averag=
e flush
>> > times, as was discovered when I studied the v6 patch.
>> >
>> > Unfortunately, there is one very odd regression: elm3c44_sas. =A0This =
profile is
>> > a couple of battery-backed RAID cabinets striped together with raid0 o=
n md. =A0I
>> > suspect that there is some sort of problematic interaction with md, be=
cause
>> > running ffsb on the individual hardware arrays produces numbers simila=
r to
>> > elm3c71_extsas. =A0elm3c71_extsas uses the same type of hardware array=
 as does
>> > elm3c44_sas, in fact.
>> >
>> > FYI, the flush coordination patch shows performance improvements both =
with and
>> > without Christoph's patch that issues pure flushes directly. =A0The sp=
readsheet
>> > only captures the performance numbers collected without Christoph's pa=
tch.
>> Hi,
>> can you explain why there is improvement with your patch? If there are
>> multiple flush, blk_do_flush already has queue for them (the
>> ->pending_flushes list).
>
> With the current code, if we have n threads trying to issue flushes, the =
block
> layer will issue n flushes one after the other. =A0I think the point of
> Christoph's pure-flush patch is to skip the serialization step and allow
> issuing of the n pure flushes in parallel. =A0The point of this patch is =
optimize
> even more aggressively, such that as soon as the system becomes free to p=
rocess
> a pure flush (at time t), all the requests for a pure flush that were cre=
ated
> since the last time a pure flush was actually issued can be covered with =
a
> single flush issued at time t. =A0In other words, this patch tries to red=
uce the
> number of pure flushes issued.
Thanks, but why just doing merge for pure flush? we can merge normal
flush requests
with a pure flush request too.

+               complete_all(&new_flush->ready);
+               spin_unlock(&disk->flush_flag_lock);

-       bio_put(bio);
+               complete_all(&flush->finish);
this seems can't guarantee the second waiter runs after the first
waiter, am I missing anything?

it appears we can easily implement this in blk_do_flush, I had
something at my hand too, passed test but no data yet.

--001485f46e5a6fc4960499c3f534
Content-Type: text/x-patch; charset=US-ASCII; name="blk-flush.patch"
Content-Disposition: attachment; filename="blk-flush.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_giwdpd900

VGFzazE6IC4uLkZTLi4uLi5DClRhc2syOiAuLi4uRi4uLi4uLlMuLi5DClRhc2szOiAuLi4uLi5G
Li4uLi4uLi4uUy4uQwpGIG1lYW5zIGEgZmx1c2ggaXMgcXVldWVkLCBTIG1lYW5zIGEgZmx1c2gg
aXMgZGlzcGF0Y2hlZCwgQyBtZWFucyB0aGUgZmx1c2gKaXMgY29tcGxldGVkLiBJbiBhYm92ZSwg
d2hlbiBUYXNrMidzIGZsdXNoIGlzIGNvbXBsZXRlZCwgd2UgYWN0dWFsbHkgY2FuCm1ha2UgVGFz
azMgZmx1c2ggY29tcGxldGUsIGFzIFRhc2syJ3MgZmx1c2ggaXMgZGlzcGF0Y2hlZCBhZnRlciBU
YXNrMydzIGZsdXNoCmlzIHF1ZXVlZC4gV2l0aCB0aGUgc2FtZSByZWFzb24sIHdlIGNhbid0IG1l
cmdlIFRhc2syIGFuZCBUYXNrMydzIGZsdXNoIHdpdGgKVGFzazEncy4KLS0tCiBibG9jay9ibGst
Y29yZS5jICAgICAgIHwgICAgMSArCiBibG9jay9ibGstZmx1c2guYyAgICAgIHwgICAyNCArKysr
KysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUvbGludXgvYmxrZGV2LmggfCAgICAyICsrCiAz
IGZpbGVzIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC9ibG9jay9ibGst
Y29yZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4Lm9yaWcvYmxvY2svYmxrLWNvcmUuYwkyMDExLTAx
LTEzIDIxOjAyOjI0LjAwMDAwMDAwMCArMDgwMAorKysgbGludXgvYmxvY2svYmxrLWNvcmUuYwky
MDExLTAxLTEzIDIxOjQzOjAzLjAwMDAwMDAwMCArMDgwMApAQCAtMTI4LDYgKzEyOCw3IEBAIHZv
aWQgYmxrX3JxX2luaXQoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEKIAlycS0+cmVmX2NvdW50ID0g
MTsKIAlycS0+c3RhcnRfdGltZSA9IGppZmZpZXM7CiAJc2V0X3N0YXJ0X3RpbWVfbnMocnEpOwor
CXJxLT5uZXh0X2JhdGNoZWRfZmx1c2ggPSBOVUxMOwogfQogRVhQT1JUX1NZTUJPTChibGtfcnFf
aW5pdCk7CiAKSW5kZXg6IGxpbnV4L2Jsb2NrL2Jsay1mbHVzaC5jCj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxp
bnV4Lm9yaWcvYmxvY2svYmxrLWZsdXNoLmMJMjAxMS0wMS0xMyAyMTowMjoyNC4wMDAwMDAwMDAg
KzA4MDAKKysrIGxpbnV4L2Jsb2NrL2Jsay1mbHVzaC5jCTIwMTEtMDEtMTQgMDg6MjI6NTYuMDAw
MDAwMDAwICswODAwCkBAIC00Miw4ICs0MiwxOCBAQCBzdGF0aWMgc3RydWN0IHJlcXVlc3QgKmJs
a19mbHVzaF9jb21wbGV0CiAJCS8qIG5vdCBjb21wbGV0ZSB5ZXQsIHF1ZXVlIHRoZSBuZXh0IGZs
dXNoIHNlcXVlbmNlICovCiAJCW5leHRfcnEgPSBxdWV1ZV9uZXh0X2ZzZXEocSk7CiAJfSBlbHNl
IHsKKwkJc3RydWN0IHJlcXVlc3QgKnRtcF9ycSA9IHEtPm9yaWdfZmx1c2hfcnEtPm5leHRfYmF0
Y2hlZF9mbHVzaDsKKwkJc3RydWN0IHJlcXVlc3QgKnRtcF9ycTI7CisJCXNlY3Rvcl90IGVycm9y
X3NlY3RvciA9IHEtPm9yaWdfZmx1c2hfcnEtPmJpby0+Ymlfc2VjdG9yOworCiAJCS8qIGNvbXBs
ZXRlIHRoaXMgZmx1c2ggcmVxdWVzdCAqLwogCQlfX2Jsa19lbmRfcmVxdWVzdF9hbGwocS0+b3Jp
Z19mbHVzaF9ycSwgcS0+Zmx1c2hfZXJyKTsKKwkJd2hpbGUgKHRtcF9ycSkgeworCQkJdG1wX3Jx
MiA9IHRtcF9ycS0+bmV4dF9iYXRjaGVkX2ZsdXNoOworCQkJdG1wX3JxLT5iaW8tPmJpX3NlY3Rv
ciA9IGVycm9yX3NlY3RvcjsKKwkJCV9fYmxrX2VuZF9yZXF1ZXN0X2FsbCh0bXBfcnEsIHEtPmZs
dXNoX2Vycik7CisJCQl0bXBfcnEgPSB0bXBfcnEyOworCQl9CiAJCXEtPm9yaWdfZmx1c2hfcnEg
PSBOVUxMOwogCQlxLT5mbHVzaF9zZXEgPSAwOwogCkBAIC0xNjQsNiArMTc0LDIwIEBAIHN0cnVj
dCByZXF1ZXN0ICpibGtfZG9fZmx1c2goc3RydWN0IHJlcXUKIAkgKiBwcm9jZXNzaW5nLgogCSAq
LwogCWlmIChxLT5mbHVzaF9zZXEpIHsKKwkJc3RydWN0IHJlcXVlc3QgKnRtcF9ycTsKKworCQlp
ZiAoKHJxLT5jbWRfZmxhZ3MgJiBSRVFfRlVBKSB8fCBibGtfcnFfc2VjdG9ycyhycSkpCisJCQln
b3RvIGFkZF9saXN0OworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHRtcF9ycSwgJnEtPnBlbmRpbmdf
Zmx1c2hlcywgcXVldWVsaXN0KSB7CisJCQlpZiAodG1wX3JxLT5jbWRfZmxhZ3MgJiBSRVFfRkxV
U0gpIHsKKwkJCQlycS0+bmV4dF9iYXRjaGVkX2ZsdXNoID0KKwkJCQkJdG1wX3JxLT5uZXh0X2Jh
dGNoZWRfZmx1c2g7CisJCQkJdG1wX3JxLT5uZXh0X2JhdGNoZWRfZmx1c2ggPSBycTsKKwkJCQls
aXN0X2RlbF9pbml0KCZycS0+cXVldWVsaXN0KTsKKwkJCQlyZXR1cm4gTlVMTDsKKwkJCX0KKwkJ
fQorYWRkX2xpc3Q6CiAJCWxpc3RfbW92ZV90YWlsKCZycS0+cXVldWVsaXN0LCAmcS0+cGVuZGlu
Z19mbHVzaGVzKTsKIAkJcmV0dXJuIE5VTEw7CiAJfQpJbmRleDogbGludXgvaW5jbHVkZS9saW51
eC9ibGtkZXYuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC5vcmlnL2luY2x1ZGUvbGludXgvYmxrZGV2
LmgJMjAxMS0wMS0xMyAyMTowMjoyNC4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4L2luY2x1ZGUv
bGludXgvYmxrZGV2LmgJMjAxMS0wMS0xMyAyMTo0MzowMy4wMDAwMDAwMDAgKzA4MDAKQEAgLTE2
Myw2ICsxNjMsOCBAQCBzdHJ1Y3QgcmVxdWVzdCB7CiAKIAkvKiBmb3IgYmlkaSAqLwogCXN0cnVj
dCByZXF1ZXN0ICpuZXh0X3JxOworCisJc3RydWN0IHJlcXVlc3QgKm5leHRfYmF0Y2hlZF9mbHVz
aDsKIH07CiAKIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgc2hvcnQgcmVxX2dldF9pb3ByaW8oc3Ry
dWN0IHJlcXVlc3QgKnJlcSkK
--001485f46e5a6fc4960499c3f534--
