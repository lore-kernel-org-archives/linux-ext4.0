From: Boxi Liu <boxi10liu@gmail.com>
Subject: Re: there is a BUG in disk full case in inlinedata feature.
Date: Tue, 22 Oct 2013 00:22:34 +0800
Message-ID: <CAAFszuVbYCGY=OR+EJrmh9Ta+jobuaRx8PfC9vE+V3ynDDS=yw@mail.gmail.com>
References: <CAAFszuVts-gn85SqPje=dibGFVo9GH6RKSJiOP6KtkZTgdDYNQ@mail.gmail.com>
	<521D4CB2.2060805@tao.ma>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b6789b414d07404e942b1d3
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>, Theodore Tso <tytso@mit.edu>,
	"lewis.liulei" <lewis.liulei@huawei.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f51.google.com ([209.85.128.51]:38478 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3JUQWf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 12:22:35 -0400
Received: by mail-qe0-f51.google.com with SMTP id q19so3915852qeb.38
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 09:22:34 -0700 (PDT)
In-Reply-To: <521D4CB2.2060805@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--047d7b6789b414d07404e942b1d3
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

hi,
I make the format patch about the inline_data patch .
Is there anything incomplete=A3=BF

Thanks
boxi

2013/8/28 Tao Ma <tm@tao.ma>:
> Hi Boxi,
>         Thanks for the detailed explanation and the bug fix. It looks goo=
d to me.
>         So would you mind send out a formal patch?
>
> Thanks,
> Tao
> On 08/28/2013 01:09 AM, Boxi Liu wrote:
>> there is a BUG in EXT4 inlinedata feature when the disk is full(0B).
>> tast case:
>>     step1: use the dd to make the disk full,has 0B remained.
>>     step2: touch a inlinedata file
>>            echo -n "123456" >> test.txt
>>     step3: make the inlinedata file test.txt convert to extent block.
>>            echo -n
>> "12345678901234567890123456789012345678901234567890123456789012345678901=
234567890123456789012345678901234567890123456789012345678901234567890123456=
7890">>test.txt
>> the step3 will write failed.and print the BUG Backtrace:
>> page:c1963bc0 count:-1 mapcount:0 mapping: (null) index:0x0
>> page flags:0x40000000()
>> Backtrace:
>> [<c004e180>] (dump_backtrace + 0x0/0x12c) from [<c07724ac>]
>> (dump_stack +0x18/0x1c)
>> r6:c0043a84  r5:c0bb688  r4:c1963bc0 r3:00000000
>> [<c0772494>] (dump_stack + 0x0/0x1c) from [<c00f6dd4>] (bad_page + 0xbc/=
0x13c)
>> [<c00fbd18>] (bad_page + 0x0/0x13c) from [<c00f74b80>]
>> (get_page_from_freelist + 0x4cc/0xb6c)
>> r7:c1963bd8 r6:c0043194 r5:c1963bc0 r4:00000001
>> [<c00f6fec>] (get_page_from_freelist +0x0/0xb6c) from [<c00f8148>]
>> (__alloc_pages_nodemask + 0x144/0x820)
>> [<c00f8004>] (__alloc_pages_nodemask +0x0/0x820) from [<c0115250>]
>> (handle_pte_fault + 0x574/0x758)
>> [<c0114cdc>] (handle_pte_fault + 0x0/0x758) from [<c0115500>]
>> (handle_mm_fault + 0xcc/0x110)
>> [<c0115434>] (handel_mm_fault + 0x0/0x110) from [<c00521a8>]
>> (do_page_fault + 0x16c/0x1f4)
>> [<c005203c>] (do_page_fault + 0x0/0x1f4) from [<c00440d0>]
>> (do_DataAbort + 0x40/0xac)
>> [<c0044090>] (do_DataAbort + 0x0/0xac) from [<c004a064>]
>> (ret_from_exception + 0x0/0x10)
>>
>> And when the system reboot , the step2 data "123456" will alse lost.
>> You can cat the test.txt,but there is no data in the file.
>> the reason is when the inlinedata convert to extent in the limit case,
>> the inlinedata read to the page,then destory the inlinedata,next step
>> is to __block_write_begin,but it can't get block,return -ENOSPC. so
>> the data lost.
>>
>> there is a patch may fix the bug:
>> in inline.c ext4_convert_inline_data_to_extent
>>
>>          needed_blocks =3D ext4_writepage_trans_blocks(inode);
>>
>> +        if(EXT4_C2B(sbi,percpu_counter_read_positive(&sbi->s_freecluste=
rs_counter))
>> < needed_blocks)
>> +               return -ENOSPC;
>> +
>>          ret =3D ext4_get_inode_loc(inode, &iloc);
>>          if (ret)
>>                  return ret;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

--047d7b6789b414d07404e942b1d3
Content-Type: application/octet-stream;
	name="0001-ext4-fix-an-ext4-inline_data-feature-file-bug.patch"
Content-Disposition: attachment;
	filename="0001-ext4-fix-an-ext4-inline_data-feature-file-bug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hn1ww2nx0

RnJvbSBmNDE5NGE4NWYwZDRkMjIxZDJhYTQ5NTU1ZDkwMDM2ODk1NjA1ZGU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCb3hpTGl1IDxsZXdpcy5saXVsZWlAaHVhd2VpLmNvbT4KRGF0
ZTogVHVlLCAyMiBPY3QgMjAxMyAwMDowMjowMSArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGV4dDQ6
Zml4IGFuIGV4dDQgaW5saW5lX2RhdGEgZmVhdHVyZSBmaWxlIGJ1ZwoKd2hlbiB0aGUgc3BhY2Ug
aXMgZnVsbCBhbmQgdGhlIGZpbGUgd2lsbCBleHBlbmQKdG8gdGhlIGJsb2NrLGZvcmJpZCBhbGxv
YyB0aGUgYmxvY2sgdG8gdGhlCmlubGluZV9kYXRhIGZlYXR1cmUgZmlsZSxrZWVwIHRoZSBmaWxl
IG9yaWdpbmFsLgoKU2lnbmVkLW9mZi1ieTogTGVpTGl1IDxsZXdpcy5saXVsZWlAaHVhd2VpLmNv
bT4KLS0tCiBmcy9leHQ0L2lubGluZS5jIHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9pbmxpbmUuYyBiL2ZzL2V4dDQvaW5saW5l
LmMKaW5kZXggYzNlZmI2NS4uYmUxYjZjYSAxMDA2NDQKLS0tIGEvZnMvZXh0NC9pbmxpbmUuYwor
KysgYi9mcy9leHQ0L2lubGluZS5jCkBAIC01MjksNiArNTI5LDcgQEAgc3RhdGljIGludCBleHQ0
X2NvbnZlcnRfaW5saW5lX2RhdGFfdG9fZXh0ZW50KHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBw
aW5nLAogCXN0cnVjdCBwYWdlICpwYWdlID0gTlVMTDsKIAl1bnNpZ25lZCBmcm9tLCB0bzsKIAlz
dHJ1Y3QgZXh0NF9pbG9jIGlsb2M7CisJc3RydWN0IGV4dDRfc2JfaW5mbyAqc2JpID0gRVhUNF9T
Qihpbm9kZS0+aV9zYik7CiAKIAlpZiAoIWV4dDRfaGFzX2lubGluZV9kYXRhKGlub2RlKSkgewog
CQkvKgpAQCAtNTQxLDYgKzU0Miw5IEBAIHN0YXRpYyBpbnQgZXh0NF9jb252ZXJ0X2lubGluZV9k
YXRhX3RvX2V4dGVudChzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywKIAogCW5lZWRlZF9i
bG9ja3MgPSBleHQ0X3dyaXRlcGFnZV90cmFuc19ibG9ja3MoaW5vZGUpOwogCisJaWYoRVhUNF9D
MkIoc2JpLHBlcmNwdV9jb3VudGVyX3JlYWRfcG9zaXRpdmUoJnNiaS0+c19mcmVlY2x1c3RlcnNf
Y291bnRlcikpIDwgbmVlZGVkX2Jsb2NrcykKKwkJcmV0dXJuIC1FTk9TUEM7CisKIAlyZXQgPSBl
eHQ0X2dldF9pbm9kZV9sb2MoaW5vZGUsICZpbG9jKTsKIAlpZiAocmV0KQogCQlyZXR1cm4gcmV0
OwotLSAKMS44LjEubXN5c2dpdC4xCgo=
--047d7b6789b414d07404e942b1d3--
