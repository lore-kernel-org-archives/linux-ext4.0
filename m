From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] fstests: make some xfs project quota tests generic
Date: Fri, 23 Sep 2016 07:20:40 -0500
Message-ID: <a834fc9c-c406-022f-8304-2ed54c65bc9b@sandeen.net>
References: <ffeed0c4-7e77-a7a0-1426-0890bf38a52f@redhat.com>
 <20160923042500.GV27776@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eryu Guan <eguan@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20160923042500.GV27776@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/22/16 11:25 PM, Eryu Guan wrote:
>> @@ -210,16 +226,23 @@ _qmount_option()
>> >  		-e 's/gquota/QUOTA/g'      \
>> >  		-e 's/grpquota/QUOTA/g'    \
>> >  		-e 's/pquota/QUOTA/g'      \
>> > -		-e 's/prjquota/QUOTA/g'      \
>> > +		-e 's/prjquota/QUOTA/g'    \
>> >  		-e 's/quota/QUOTA/g'       \
>> >  		-e 's/uqnoenforce/QUOTA/g' \
>> >  		-e 's/gqnoenforce/QUOTA/g' \
>> >  		-e 's/pqnoenforce/QUOTA/g' \
>> >  		-e 's/qnoenforce/QUOTA/g'  \
>> > -		-e "s/QUOTA/$1/g"`
>> > +		-e "s/QUOTA/$OPTS/g"`
>> >  
>> > +	# ext4 doesn't _do_ "-o pquota/prjquota" because reasons
>> > +	# Switch it to "quota" to enable mkfs-time pquota
>> > +	if [ "$FSTYP" == "ext4" ]; then
>> > +		OPTS=`echo $OPTS \
>> > +		| sed	-e 's/pquota/quota/g'	\
>> > +			-e 's/prjquota/quota/g'`
>> > +	fi
> This replaces "grpquota" to "grquota" and mount failed because of
> unknown mount option "grquota". The following change works for me:
> 
> -             | sed   -e 's/pquota/quota/g'   \
> +             | sed   -e 's/\bpquota/quota/g' \
> 
> If you can give me an ack (or another fix), I can fold it into the
> original patch.

Eek .. yes, feel free to change that (and the other, unless you want
to make it a separate commit) - sorry, not sure how I missed that.

Thanks,
-Eric
